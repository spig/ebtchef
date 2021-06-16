class PublicController < ApplicationController
  layout 'public', :except => [ 'cvv_help', 'do_login', 'referrer_signup' ]

  include ExceptionNotifiable

  filter_parameter_logging :credit_card, :checking_account, :routing_number, :email, :ccexp, :address, :state

  before_filter :check_promo
  before_filter :set_protocol
  before_filter :require_ssl, :only => ['signup', 'submit_signup', 'do_login']

  # caches_page :legal, :faq, :learn_more, :how_chef_works, :example_shopping_list, :example_meal_plan

  def initialize
    @views = {'index' => 1} # 1 is penny page
    @layouts = {'index' => 1}
    $view_visit_count['index'] ||= 0
    $layout_visit_count['index'] ||= 0
  end

  def index
    # raise $view_visit_count.inspect 
    # raise  $layout_visit_count.inspect
    $view_visit_count['index'] += 1 unless cookies['vtr']
    #cookies['vtr'] ||= view_to_render('index')
    $layout_visit_count['index'] += 1 unless cookies['ltr']
    #cookies['ltr'] ||= layout_to_use('index')
    # render :action => cookies['vtr'] ||= view_to_render('index'), :layout => cookies['ltr'] ||= layout_to_use('index')
    render :action => view_to_render('index'), :layout => layout_to_use('index') # force render to penny page
  end

  def signup
    @user ||= User.new(params[:user])
    @user.credit_or_check = 'credit'
    @user.ccexp_year = Time.now.year
    @user.ccexp_month = Time.now.month
    render :action => 'signup', :layout => 'index_1'
  end

  def submit_signup
    @user = User.new(params[:user])
    @user.remote_ip = request.remote_ip
    @user.referrer_id = cookies['rmid']
    @user.referrer = cookies['ref']
    @user.affiliate_id = cookies['affid']
    @user.sub_affiliate_id = cookies['sub_affid']
    begin
    rescue
      logger.info "EXCEPTION CAUGHT in #{__FILE__} at line #{__LINE__}\n#{e.message}"
    end
    # leadburst shanes page hack 3-7-2007
    if @user.referrer =~ /secure.orderssafe.com/ and @user.affiliate_id = "LB2007"
      @user.layout_used = "shanes_page"
    else
      @user.layout_used = cookies['ltr'] || layout_to_use('index')
    end
    # end leadburst shanes page hack
    @user.recurrence = params[:offer]
#    logger.info "promo info: #{@promo.inspect}"
#    if @promo and @promo.price > 0 and @promo.days_to_first_billing > 0
#      @user.price = @promo.price
#      @user.next_billing_on = @promo.days_to_first_billing
#puts "Price P #{@user.price}"
#    else
      if params[:offer] == 'yearly'
        @user.price = (Promo::DefaultYearlyPrice || 4995)
#puts "Price Y #{@user.price}"
      else
        @user.price = (Promo::DefaultMonthlyPrice || 495)
#puts "Price M #{@user.price}"
      end
      @user.next_billing_on = Promo::DefaultDaysToFirstBilling || 14
#    end
    # raise @promo.inspect
    # raise @user.inspect
    if @user.save
      session[:user_id] = @user.id
      #case
      #when (@promo and @promo.days_to_first_billing >= 30)
      #  Notifications.deliver_welcome_free30_email(@user)
      #when (@promo and @promo.days_to_first_billing >= 14)
      #  #Notifications.deliver_welcome_free14_email(@user)
      #  Notifications.deliver_trial_day00 @user
      #else
        # Notifications.deliver_welcome_email(@user)
        #Notifications.deliver_welcome_free14_email(@user)
        Notifications.deliver_trial_day00 @user
      #end
      # if this memeber was referred then send a email to the referrer
      if cookies['rmid']
        new_referral = Referral.find(:first, :conditions => ["referrer_id = ? and referred_id =?", cookies['rmid'].to_i, @user.id])
        # send notice to member referrer
        Notifications.deliver_member_referral_signed_up(User.find_by_id(cookies['rmid'].to_i),@user)
      end
      flash[:notice] = "Your account was created successfully"
      @order_id = @user.id
      render :action => 'thank_you', :layout => 'member'
      # do_login @user
      # render :action => 'do_login', :layout => false
    else
      render :action => "signup", :layout => 'member'
    end
  rescue Payment::PaymentError => e
    matches = e.message.match(/(\d+)/)
    failure_code = matches[1].to_i if (matches and matches.size > 0)
    failure_code ||= 0
    case failure_code
      when 1511
        @user.errors.add_to_base("Payment authorization has already occurred (#{failure_code}).  Please return to <a href=\"http://ebtchef.com/\">login</a>.");
      else
        @user.errors.add_to_base("Payment authorization failed (#{failure_code}).  Please verify all information.");
    end
    flash[:notice] = "The following errors prevented your subscription:\n" + @user.errors.full_messages.join("\n")
    render :action => 'signup', :layout => 'signup'
  end

  def thank_you
    # @order_id = @user.id
    render :action => 'thank_you', :layout => 'member'
  end
  
  def terms_of_service
    
  end
  
  def referrer_signup
    # if request.post?
      begin
        @user = User.new
        @user.post_referral = true
        @user.credit_or_check = 'credit'
        @user.first_name = params[:billing_firstname]
        @user.last_name = params[:billing_lastname]
        @user.email = params[:billing_email]
        @user.password = params[:password]
        @user.credit_card_number = params[:cc_number]
        @user.ccexp_month = params[:ccexp_month]
        @user.ccexp_year = params[:ccexp_year]
        @user.city = params[:billing_city]
        @user.state = params[:billing_state]
        @user.zip = params[:billing_zip]
        @user.remote_ip = params[:billing_ip_address]
        @user.address = params[:address1]
        @user.billing_info = params[:auth_code]
        @user.recurrence = params[:recurrence] || "monthly"
        @user.price = @user.recurrence == "monthly" ? 495 : 4995
        @user.affiliate_id = "LB2007" # TODO remove hack for Leadburst
        if (params[:trial_length].to_i > 0)
          @user.next_billing_on = params[:trial_length].to_i
        else
          @user.next_billing_on = 30
        end
        if @user.save # skip validation
          if params[:trial_length].to_i > 0
            Notifications.deliver_welcome_free30_email(@user)
          else
            #Notifications.deliver_welcome_free_email(@user)
            Notifications.deliver_trial_day00 @user
          end
          @status = "Success: new account created."
        else
          @status = "Failed: #{@user.errors.full_messages.join(', ')}"
        end
      rescue TypeError => e
        @status = "Failed: #{e}. #{@user.errors.full_messages.join(',')}"
      end
  # end
    render :text => @status, :layout => false
  end
  
  def login
  end
  
  
  def logout
    reset_session
    #flash[:notice] = "Logged Out"
    cookies.delete :logged_in
	redirect_to :action => 'index', :protocol => "http://"
  end
  
  def how_chef_works
    @page_css = 'how_chef_works'
  end
  
  def learn_more
    @show_signup = true
  end
  
  def do_login user=nil
    unless user
      # user = User.find(session[:user_id]) if session[:user_id] #this is problematic as session is tied to a browsers cookie
      unless user 
        email = params[:email] || params[:user][:email] if params[:user] or params[:email]
        password = params[:password] || params[:user][:password] if params[:user] or params[:password]
        user = User.valid?(email, password)
      end
    end
    
    if user
      session[:user_id] = user.id
      @url = 'http://'+request.host_with_port+member_path
      uri = session[:original_uri] 
      session[:original_uri] = nil 
      redirect_to(uri || @url)
      # redirect_to(uri || { :action => "index" })
    else
      flash[:notice] = "Invalid email address or password.\nPlease try again."
      redirect_to member_login_url and return
    end
  end

  def faq
  end

  def legal
  end

  def contact
    @user ||= User.find(session[:user_id]) if session[:user_id]
    @user ||= User.new
    @topic = params[:topic] || 'general'
    @page_css = 'contact'
  end
  
  def send_contact_form
    headers = Hash.new
    case params[:topic]
    when 'general'
      subject = "General Question or Suggestion"
      recipient = '"Ask the Chef" <askthechef@ebtchef.com>'
      headers['cc'] = '"Jeff Burningham" <jeff@ebtchef.com>'
      headers['bcc'] = '"Troy Heninger" <troy@ebtchef.com>'
    when 'service'
      subject = "Customer Service"
      recipient = '"Customer Service" <service@ebtchef.com>'
      headers['cc'] = '"Jeff Burningham" <jeff@ebtchef.com>'
      headers['bcc'] = '"Troy Heninger" <troy@ebtchef.com>'
    when 'technical'
      subject = "Technical Support"
      recipient = '"Technical Support" <techsupport@ebtchef.com>'
      headers['cc'] = '"Jeff Burningham" <jeff@ebtchef.com>'
      headers['bcc'] = '"Troy Heninger" <troy@ebtchef.com>'
    when 'billing'
      subject = "Billing"
      recipient = '"Billing" <billing@ebtchef.com>'
      headers['cc'] = '"Jeff Burningham" <jeff@ebtchef.com>'
      headers['bcc'] = '"Troy Heninger" <troy@ebtchef.com>'
    end
    
    if (session[:user_id])
      user = User.find(session[:user_id])
      headers['x_sent_user'] = user.id
    end

    valid_email_user = User.new(:email => params[:email], :first_name => params[:name])
    if (! valid_email_user.valid? and ! valid_email_user.errors.on(:email)) or params[:message].to_s.empty?
      flash.now[:error] = "Please submit a question and verify that your email address is correct."
    else
      Notifications.deliver_contact(recipient, subject, params[:message], %Q|"#{valid_email_user.first_name}" <#{valid_email_user.email}>|, headers)
      flash.now[:notice] = "Your message has been sent.  We will respond as soon as we can.  Thank you."
    end
    @user = user || valid_email_user
    
    if ! params[:previous_controller].to_s.empty?
      flash[:notice] = flash.now[:notice] unless flash.now[:notice].to_s.empty?
      flash[:error] = flash.now[:error] unless flash.now[:error].to_s.empty?
      redirect_to :controller => params[:previous_controller], :action => params[:previous_action], :topic => params[:topic]
    else
      @page_css = 'contact'
      @topic = params[:topic] || 'general'
      render :template => 'public/contact'
    end
  end
  
  def example_meal_plan
    @partial = 'example_meal_plan'
    @page_css = ['mealplan', 'examplemealplans', [ 'print', {:media => 'print'} ] ]
  end
  
  def example_shopping_list
    @partial = 'example_shopping_list'
    @page_css = ['shopping_list', 'examplemealplans', [ 'print', {:media => 'print'} ] ]
    render :action => 'example_meal_plan'
  end
  
  private

  def layout_to_use layout
    layout = layout.to_s if layout.kind_of? Symbol
    # layout + '_' + ($layout_visit_count[layout] % @layouts[layout]).to_s
    layout + '_' + (@layouts[layout]).to_s
  end
  
  def view_to_render view
    view = view.to_s if view.kind_of? Symbol
    # view + '_' + ($view_visit_count[view] % @views[view]).to_s
    view + '_' + (@views[view]).to_s
  end
  
  def check_promo
    # hack for bad meridian url
    params[:c] = 'meridian' and params[:h] = '-963291257' if params[:c] == 'me'
    
    if %w(c e h).inject(true) { |av,n| av && params.has_key?(n.to_sym) }
      @promo = Promo.validate(params[:c], params[:e], params[:h]) #promo code, email, hash
      cookies['promo'] = "#{params[:c]}|#{params[:e]}|#{params[:h]}"
    else
      # @promo = Promo.validate(cookies['promo'])
      @promo = Promo.find_by_name("direct")
    end
    true
  end
  
  def set_protocol
    # only render in ssl if coming from a remote site - ssl no-workie in local
    #@protocol = (RAILS_ENV.match(/development/) and ! @request.ssl?) ? 'http://' : 'https://'
    @protocol = RAILS_ENV == 'production' || @request.ssl? ? 'https://' : 'http://'
    true
  end
  
end
