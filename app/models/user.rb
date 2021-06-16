class User < ActiveRecord::Base
  ACCEPTED_CREDIT_CARDS = ["VISA", "AMEX", "MC"]
  CANCEL_REASONS = ["PLEASE SELECT ONE","Didn't like the recipes offered because they didn't meet dietary needs/preferences","Recipes were too difficult","Recipes were too time consuming","Didn't care for the recipes offered","Recipe servings are too large or too small for my family","Can't afford the subscription price","Didn't understand how this service works","Other"]
  EMAIL_REGEX = /^([^@<>\[\]{}\(\)\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  # Failure notice; key it the error count number with a hash of params, param 0 is the notification day sent and param 1 is the next bill days from now
  FAILURE_NOTICE = {1 =>[0,3],2 => [3,4], 3 => [7,7], 4 => [14,7], 5 => [21,7], 6 => [28]}
  has_many :favorite_recipes, :uniq => true
  has_many :recipes, :through => :favorite_recipes, :uniq => true
  has_many :referral_logs
  has_many :user_logs
  has_many :billings

  attr_accessor :password, :credit_card_number, :credit_card_verification, :checking_account, :credit_or_check, :credit_card_type, :ccexp_month, :ccexp_year, :remote_ip, :referrer_id, :post_referral
  attr_protected :ccnum, :checkacct, :admin

  validates_presence_of :first_name, :last_name#, :address, :city, :state, :zip
  validates_presence_of :password, :if => Proc.new { |user| ! user.hash_password || user.hash_password.empty? }
#  validates_uniqueness_of :email, :if => Proc.new { |user| user.email && ! user.email.empty? }
  validates_format_of :email, :with => EMAIL_REGEX, :message => 'is not valid'
  validates_confirmation_of :password, :email
  validates_inclusion_of :recurrence, :in => %w( monthly yearly ), :allow_nil => true
  
  # this method is used for the affiliate login via the admin/login controller
  def self.login(username, password)
    hashed_password = User.hash(password || "")
    find(:first, :conditions => ["user_name = ? and hash_password = ?", username, hashed_password])
  end
  
  def password= password
    self.hash_password = User.hash(password)
    @password = password
  end

  def free_trial?
    if next_billing_on
      next_billing_on.to_time > Time.now() && last_billed_on == nil
    end
  end
  
  def check_or_credit
    if (ccnum.to_s.strip.empty?)
      "EC"
    else
      "CR"
    end
  end
  
  def billing_number
    if (ccnum.to_s.strip.empty?)
      checkacct
    else
      ccnum
    end
  end
  
  def validate_on_create
#    # validate credit card info
#    case self.credit_or_check
#    when 'credit'
#      validate_credit_card
#    when 'check'
#      validate_checking_account
#      validate_phone_field
#    else
#      self.errors.add('Credit or Checking Account', 'must be specified to subscribe') unless new_record?
#    end
    ensure_unique_email
  end
  
  def validate_on_update
    if ! credit_card_number.to_s.empty?
      validate_credit_card
    elsif ! checking_account.to_s.empty?
      validate_checking_account
      validate_phone_field
    end
    ensure_unique_email
    unless self.on_hold? || self.free_trial?
      [:address, :city, :state, :zip].each do |attr|
        self.errors.add(attr, 'cannot be blank') if send(attr).blank?
      end
    end
  end

  def ensure_unique_email
    same_user = User.find :first, :conditions=>["email = ?#{new_record? ? '' : ' and not id = ' + id.to_s}", email]
    return if same_user == nil
    if same_user.cancelled_on.nil? || same_user.cancelled_on > 1.month.ago.to_date
      errors.add(:email, 'address is already in our system')
    else
      same_user.destroy
    end
 end

  def validate_credit_card
    if self.credit_card_number.blank?
      self.errors.add(:credit_card_number, 'is not specified')
    else
      self.errors.add(:credit_card_number, 'is not valid') unless self.valid_cc? self.credit_card_number
      self.errors.add(:credit_card_number, 'is not a credit card we accept') unless self.credit_card_number.empty? || self.valid_cc_type?(self.credit_card_number, ACCEPTED_CREDIT_CARDS)
      self.errors.add(:credit_card_number, 'is expired') unless
      self.checking_account = '' if self.errors.empty?
      self.routing_number = '' if self.errors.empty?
    end
  end
  
  def validate_checking_account
    self.errors.add(:checking_account, 'is not valid') unless self.checking_account.match(/^\d+$/)
    self.errors.add(:routing_number, 'is not valid') unless self.routing_number.match(/^\d+$/)
    self.credit_card_number = '' if self.errors.empty?
    self.credit_card_verification = '' if self.errors.empty?
    self.cc_exp = '' if self.errors.empty?
  end
  
  def validate_phone_field
    # check phone number for 10 digits (remove all non-digits before sending out to database
    self.phone.gsub!(/\D/, '') unless self.phone.nil?
    if (self.phone.nil?)
      self.errors.add(:phone, 'is not valid')
    elsif (self.phone.size == 7)
      self.errors.add(:phone, 'must contain area code')
    elsif (self.phone.size != 10)
      self.errors.add(:phone, 'is not valid')
    end
  end
  
  def before_update
    self.hash_password = User.hash(password) if password
    if ! credit_card_number.to_s.empty?
      self.ccnum = User.mask_ccnumber(credit_card_number)
      self.checkacct = nil
      self.routing_number = nil
      self.phone = nil
    elsif ! checking_account.to_s.empty?
      self.checkacct = User.mask_checkaccount(checking_account)
      self.ccnum = nil
      self.cc_exp = nil
    end
    
    unless credit_card_number.to_s.empty? and checking_account.to_s.empty?
      encrypted_out = checking_account.to_s.empty? ? $encrypter.encrypt_to_base64('credit:' + credit_card_number) : $encrypter.encrypt_to_base64('check:' + checking_account)
      self.billing_info = encrypted_out
    end
    
    # clear out secure fields on method exit
    self.credit_card_number = self.checking_account = nil
  end
  
  def before_create
    self.hash_password = User.hash(password) if password
    self.ccnum = User.mask_ccnumber(credit_card_number) if credit_card_number
    self.checkacct = User.mask_checkaccount(checking_account) if checking_account
    self.cc_exp = Date.new(ccexp_year.to_i, ccexp_month.to_i) if ccexp_month and ccexp_year
    self.next_billing_on = next_billing_on.days.since.to_date
  end

  def after_create
    
#    billing_options = { :order_type => 'S', :merchant_echo_id => $ECHO_MERCHANT_ID, :merchant_pin => $ECHO_MERCHANT_PIN, :billing_ip_address => self.remote_ip, :grand_total => self.price, :billing_phone => self.phone, :merchant_trace_nbr => self.email, :counter => self.email.hash.abs.to_s[0...10] }
#
#    # adjust next billing depending on promotion
#    # if no promo is specified, the next billing should always be time.now.months_since(1)
#    is_free_trial = false
#    if next_billing_on.kind_of?(Fixnum)
#      is_free_trial = true if next_billing_on > 0
#      self.next_billing_on = next_billing_on.days.since.to_date
#    else
#      if recurrence.nil? or recurrence == "monthly"        # if monthly, put next billing one month out
#        self.next_billing_on = Time.now.months_since(1)
#      elsif recurrence == "yearly"      # if yearly, put next billing one year out
#        self.next_billing_on = Time.now.years_since(1)
#      end
#    end
#    # is this a check?
#    if self.credit_card_number.to_s.strip.empty?
#      billing_options.merge!( { :ec_first_name => self.first_name, :ec_last_name => self.last_name, :ec_address1 => self.address, :ec_zip => self.zip, :ec_city => self.city, :ec_state => self.state, :ec_email => self.email } )
#      billing_options.merge!( { :transaction_type => 'DD', :ec_payment_type => 'WEB', :ec_payee => 'Everything But the Chef', :ec_account => self.checking_account, :ec_rt => self.routing_number } )
#      # set transaction_type to capture only if next_billing_on is in the future
#      billing_options.merge!( { :transaction_type => 'DV' } ) if is_free_trial
#    # is this a credit card?
#    elsif self.checking_account.to_s.strip.empty?
#      billing_options.merge!( { :billing_first_name => self.first_name, :billing_last_name => self.last_name, :billing_address1 => self.address, :billing_zip => self.zip, :billing_city => self.city, :billing_state => self.state, :billing_email => self.email } )
#      billing_options.merge!( { :transaction_type => 'EV', :cc_number => self.credit_card_number, :cnp_security => self.credit_card_verification, :ccexp_month => self.ccexp_month, :ccexp_year => self.ccexp_year } )
#      # set transaction_type to capture only if next_billing_on is in the future
#      billing_options.merge!( { :transaction_type => 'AV' } ) if is_free_trial
#    else
#      raise "Credit Card or Checking Account must be specified"
#    end
#
#    encrypted_out = self.credit_or_check == 'credit' ? $encrypter.encrypt_to_base64(self.credit_or_check + ':' + self.credit_card_number) : $encrypter.encrypt_to_base64(self.credit_or_check + ':' + self.checking_account)
#    # raise is_free_trial.to_s
#    unless post_referral
#      # raise "not working"
#      payment = Payment::EchoNet.new(billing_options)
#      payment.submit(billing_options[:transaction_type])
#    end
#    self.last_billed_on = Time.now unless is_free_trial
#    self.last_billing_response = payment.response.plain if payment
#    self.billing_info = encrypted_out
#    #
    self.created_at = Time.now
    self.save

    # save referrer information
    Referral.create(:referrer_id => self.referrer_id, :referred_id => self.id) unless self.referrer_id.to_i <= 0
    
    # remove newsletter subscribers with the same email address
    begin
      NewsletterSubscriber.find_by_email(email).destroy
    rescue
    end
    
    # remove newsletter subscribers with the same email address
    begin
      SurveyResponder.find_by_email(email).destroy
    rescue
    end

    # clear out non-hashed password
    @password = self.credit_card_number = self.credit_card_verification = self.checking_account = nil
  end
  
  def after_update
    # clear out non-hashed password
    @password = self.credit_card_number = self.credit_card_verification = self.checking_account = nil
  end

  def valid_cc_type? ccNumber, types
    ccNumber = ccNumber.gsub(/\D/, '')
    case ccNumber
    when /^3\d{14}$/ then type = "AMEX"
    when /^4\d{12}(\d{3})?$/ then type = "VISA";
    when /^5\d{15}|36\d{14}$/ then type = "MC"
    when /^6011\d{12}|650\d{13}$/ then type = "DISC"
    when /^3(0[0-5]|8[0-1])\d{11}$/ then type = "DINERS"
    when /^(39\d{12})|(389\d{11})$/ then type = "CB"
    when /^3\d{15}|1800\d{11}|2131\d{11}$/ then type = "JCB"
    else type = "NA"
    end

    types.include?(type)
  end

  def valid_cc? ccnumber # also known as the luhn check
    ccNumber = ccnumber.gsub(/\D/,'').split(//).collect { |digit| digit.to_i }
    parity = ccNumber.length % 2
    
    sum = 0
    ccNumber.each_with_index do |digit,index|
      digit = digit * 2 if index%2==parity
      digit = digit - 9 if digit > 9
      sum = sum + digit
    end
    (sum%10)==0 && ccNumber.size > 0
  end
  
  def cancel attrs
    self.attributes = attrs
    self.cancel_reason = "No Reason Specified" if self.cancel_reason.to_s.strip.empty?
    self.cancelled_on = Date.today if self.cancelled_on == nil
    self.send_weekly_reminder = false
    self.save
  end
  
  def self.valid? email, password
    User.find(:first, :conditions => [ '(cancelled_on is null or cancelled_on > now()) and email = ? and (hash_password = ? or hash_password = encrypt(?, hash_password))', email.to_s, hash(password.to_s), password.to_s ])
  end


  
  def bill_once
    if RAILS_ENV == 'development'
      return
    end
    # TODO part of this method is taken from the billing.rb script and is similar to the after_create method, factor out later to a library file to include 2/14/07 wvoll
    options = { :counter => 1, :private_key_name => "ebtchef_pk"}
    
    # create a new billing
    billing = Billing.new(:user_id => self.id)
    
    #build a set of base options per each user to be billed.
    billing_options = { :order_type => 'S', :merchant_echo_id => $ECHO_MERCHANT_ID, :merchant_pin => $ECHO_MERCHANT_PIN, :billing_ip_address => '127.0.0.1', :grand_total => self.price, :billing_phone => self.phone, :merchant_trace_nbr => self.email, :counter => options[:counter] }

    
    # make a new private key file from DB
    f = File.new("temp",'w')
    f.write(SiteConfiguration.find(:first, :conditions => ['name = ?',options[:private_key_name]]).value)
    f.close
    
    #decrypt the billing info to use for this billing
    decrypter = Sentry::AsymmetricSentry.new(:private_key_file => "temp")
    # raise decrypter.inspect
    credit_or_check, cc_or_ca_num = decrypter.decrypt_from_base64(self.billing_info).split(/:/)
    File.delete('temp')
    case credit_or_check
      when 'credit'
        self.credit_card_number = cc_or_ca_num if credit_or_check == 'credit'
        self.ccexp_month = self.cc_exp.month
        self.ccexp_year = self.cc_exp.year
      when 'check'
        self.checking_account = cc_or_ca_num if credit_or_check == 'check'
      else
        raise "Credit Card or Checking Account not found for user #{self.id} (#{self.email})"
    end
    # add additonal options to the base options
    # is this a check?
    if self.credit_card_number.to_s.strip.empty?
      billing_options.merge!( { :ec_first_name => self.first_name, :ec_last_name => self.last_name, :ec_address1 => self.address, :ec_zip => self.zip, :ec_city => self.city, :ec_state => self.state, :ec_email => self.email } )
      billing_options.merge!( { :transaction_type => 'DD', :ec_payment_type => 'WEB', :ec_payee => 'Everything But the Chef', :ec_account => self.checking_account, :ec_rt => self.routing_number } )
    # is this a credit card?
    elsif self.checking_account.to_s.strip.empty?
      billing_options.merge!( { :billing_first_name => self.first_name, :billing_last_name => self.last_name, :billing_address1 => self.address, :billing_zip => self.zip, :billing_city => self.city, :billing_state => self.state, :billing_email => self.email } )
      billing_options.merge!( { :transaction_type => 'EV', :cc_number => self.credit_card_number, :cnp_security => '', :ccexp_month => self.ccexp_month, :ccexp_year => self.ccexp_year } )
    else
      raise "Credit Card or Checking Account must be specified for user #{self.id} (#{self.email})"
    end
    
    #initialize a new payment object with the billing options
    payment = Payment::EchoNet.new(billing_options)
    
    begin
      # submit the billing and get the response
      payment.submit(billing_options[:transaction_type]) rescue nil
      self.last_billing_response = payment.response.plain
      # billing model used for historical data
      billing.response = self.last_billing_response
      billing.billed_on = Time.now
      billing.amount_billed = self.price
      if (self.last_billing_response =~ /decline_code/) != nil and self.on_hold
        billing.error_msg = "Error billing #{self.id} (#{self.email})"
        billing.status = false #failed
        self.next_billing_on = Date.today
      else
        self.last_billed_on = billing.billed_on
        if self.recurrence == 'monthly'
          self.next_billing_on = self.next_billing_on.to_time.months_since(1)
        elsif self.recurrence == 'yearly'
          self.next_billing_on = self.next_billing_on.to_time.years_since(1)
        else
          billing.error_msg =  "Can't bill this user: no recurrence for user #{self.id} (#{self.email})"
        end  
        billing.status = true #suceeded
      end
    ensure
      self.save
      billing.save
    end
    billing
  end

  def to_s
    "\"#{first_name} #{last_name}\" <#{email}>"
  end

  private

  def self.hash password
    Digest::SHA1.hexdigest(password)
  end

  def self.mask_ccnumber ccnumber
    unless ccnumber.empty?
      "***********#{ccnumber[-4..-1]}"
    else
      nil
    end
  end

  def self.mask_checkaccount checking_account
    unless checking_account.empty?
      "***********#{checking_account[-4..-1]}"
    else
      nil
    end
  end

end