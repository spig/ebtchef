class Notifications < ActionMailer::Base
  ActionMailer::Base.delivery_method = :sendmail

  def member_referral_signed_up(referrer, referred)
    @subject    = 'One Month Free Chef Service'
    @body       = { :referrer => referrer, :referred => referred}
    @recipients = referrer.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
#    @headers    = {'bcc' => '"William Voll" <wpvoll@gmail.com>,"Jeff Burningham" <jeff@ebtchef.com>'}
    bcc ['William Voll <wvoll@ebtchef.com>', 'Jeff Burningham <jeff@ebtchef.com>', 'Troy Heninger <troy@ebtchef.com']
  end
  
  def welcome_email_old(user)
    @subject    = 'Welcome to Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def welcome_free30_email_old(user)
    @subject    = 'Welcome to Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def welcome_free14_email_old(user)
    @subject    = 'Welcome to Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
    part :content_type => "text/html",
      :body => render_message("welcome_free14_email.text.html.rhtml", @body)
    attachment "application/pdf" do |a|
      a.filename= "Start-Your-Little-Engines-e-book.pdf"
      a.body = File.read(RAILS_ROOT + "/public/files/ebooks/Start-Your-LIttle-Engines-e-book.pdf")
    end
  end

  def trial_day00(user)
    @subject    = 'Welcome to Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
    part :content_type => "text/html",
      :body => render_message("trial_day00.text.html.rhtml", @body)
    attachment "application/pdf" do |a|
      a.filename= "Start-Your-Little-Engines-e-book.pdf"
      a.body = File.read(RAILS_ROOT + "/public/files/ebooks/Start-Your-LIttle-Engines-e-book.pdf")
    end
  end

  def trial_day07(user)
    @subject    = 'Welcome to Everything but the Chef--First Week'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def trial_day12(user)
    @subject    = 'Welcome to Everything but the Chef--Trial Expiring'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def trial_day16(user)
    @subject    = 'Welcome to Everything but the Chef--Trial Has Expired'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def thank_you_email(user)
    @subject    = 'Thank You for Giving Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
    part :content_type => "text/html",
      :body => render_message("thank_you_email.text.html.rhtml", @body)
    attachment "application/pdf" do |a|
      a.filename= "Discover the Perfect Christmas Eve eBook.pdf"
      a.body = File.read(RAILS_ROOT + "/public/files/ebooks/Discover the Perfect Christmas Eve eBook.pdf")
    end
    attachment "application/pdf" do |a|
      a.filename= "Chef Gift Certificate.pdf"
      a.body = File.read(RAILS_ROOT + "/public/files/ebooks/ebtc-gift2.pdf")
    end
  end

  def welcome_recipient_email_old(user)
    @subject    = 'Welcome to Everything but the Chef'
    @body       = { :user => user }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
    part :content_type => "text/html",
      :body => render_message("welcome_recipient_email.text.html.rhtml", @body)
    attachment "application/pdf" do |a|
      a.filename= "Start-Your-Little-Engines-e-book.pdf"
      a.body = File.read(RAILS_ROOT + "/public/files/ebooks/Start-Your-LIttle-Engines-e-book.pdf")
    end
  end

  def weekly(newsletter, user, email, test=false)
    @subject    = "#{if test: 'Test Subscriber Newletter--' end}Your Everything but the Chef Meals are Ready"
    @body       = { :user => user, :email_id => email.id, :newsletter=>newsletter }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
#    @headers    = {}
    bcc ['Troy Heninger <troy@ebtchef.com>','EbtChef <askthechef@ebtchef.com>'] if test
  end
  
  def weekly_nonsub(newsletter, user, email, test=false)
    @subject = "#{if test: 'Test Nonsubscriber Newletter--' end}Your Everything but the Chef Meals are Ready"
    @body       = { :user => user, :email_id => email.id, :newsletter=>newsletter }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
#    @headers    = {}
    bcc ['Troy Heninger <troy@ebtchef.com>','EbtChef <askthechef@ebtchef.com>'] if test
  end
  # below is for automated newsletter system
  # def weekly(user, email, newsletter)
  #     @subject    = 'Your Everything but the Chef Meals are Ready'
  #     @body       = { :user => user, :email_id => email.id, :letter => newsletter }
  #     @recipients = user.email
  #     @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
  #     @sent_on    = Time.now
  #     @headers    = {}
  #   end
  #   
  #   def weekly_nonsub(user, email, newsletter)
  #     @subject = 'Your Everything but the Chef Meals are Ready'
  #     @body       = { :user => user, :email_id => email.id, :letter => newsletter }
  #     @recipients = user.email
  #     @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
  #     @sent_on    = Time.now
  #     @headers    = {}
  #   end

  def jeff_personal_sell(user, email)
    @subject    = 'Exciting News from the CEO of Everything but the Chef'
    @body       = { :user => user, :email_id => email.id }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def jeff_personal_sell_non_sub(user, email)
    @subject    = 'Exciting News from the CEO of Everything but the Chef'
    @body       = { :user => user, :email_id => email.id }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def forgot_password()
    @subject    = 'Everything but the Chef Password Reset'
    @body       = {}
    @recipients = ''
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def account_on_hold()
    @subject    = 'Everything but the Chef Account on Hold'
    @body       = {}
    @recipients = ''
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def billing_failed(user, day)
    @subject    = 'Everything but the Chef - Billing Problem'
    @body       = { :user => user, :day_of => day}
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    #@headers    = {'bcc' => '"William Voll" <wpvoll@gmail.com>,"Jeff Burningham" <jeff@ebtchef.com>'}
    bcc ['William Voll <wvoll@ebtchef.com>', 'Jeff Burningham <jeff@ebtchef.com>', 'Troy Heninger <troy@ebtchef.com']
  end
  
  def billing_expiring()
    @subject    = 'Everything but the Chef Billing Expiring'
    @body       = {}
    @recipients = ''
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def members_week_before(user)
    @subject = 'Some Great News from Everything But the Chef'
    @body = {:user => user, :email => Email.find(1)}
    @recipients = "\"#{user.first_name} #{user.last_name}\" <#{user.email}>"
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def subs_week_before(newsletter_subscriber)
    @subject = 'Great News from Everything But the Chef'
    @body = {:newsletter_subscriber => newsletter_subscriber, :email => Email.find(2)}
    @recipients = newsletter_subscriber.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def survey_respondents(user)
    @subject    = 'Finally, Your New Chef Service Coupon'
    if user.respond_to?(:first_name)
      email_id = 3
      type = 'm'
      @body       = { :user => user, :email_id => email_id, :type => type }
    else
      email_id = 4
      type = 'n'
      @body       = { :user => user, :email_id => email_id, :type => type }
    end
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def member_launch(user)
    @subject    = 'Greetings from Everything but the Chef'
    @body       = { :user => user, :email_id => 5 }
    @recipients = user.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def newsletter_subscribers_launch(newsletter_subscriber)
    @subject    = 'New & Improved Chef Service – Special offer for newsletter subscribers'
    @body       = { :user => newsletter_subscriber, :email_id => 6 }
    @recipients = newsletter_subscriber.email
    @from       = '"Everything but the Chef" <no-reply@ebtchef.com>'
    @sent_on    = Time.now
    @headers    = {}
  end

  def askthechef_question(email, question)
    @subject    = 'Ask the Chef'
    @body       = { :email => email, :question => question }
    @recipients = '"The Chef" <askthechef@ebtchef.com>'
    @from       = email
    @sent_on    = Time.now
    @headers    = {'bcc' => '"Jeff Burningham" <jeff@ebtchef.com>'}
  end
  
  def tellafriend(recipient, subject, message, user)
    @subject    = subject
    @body       = { :message => message, :user => user }
    @recipients = recipient
    @from       = user.email
    @sent_on    = Time.now
    @headers    = {'bcc' => '"tell-a-friend bcc to Jeff" <jeff@ebtchef.com>'}
  end
  
  def contact(recipient, subject, message, from, headers = Hash.new)
    @subject    = subject
    @body       = message
    @recipients = recipient
    @from       = from
    @sent_on    = Time.now
    @headers    = headers
#    if headers.has_key?('bcc')
#      @headers['bcc'] = headers['bcc'] + '; "Jeff Burningham" <jeff@ebtchef.com>'
#    else
#      @headers  = {'bcc' => '"Jeff Burningham" <jeff@ebtchef.com>'}.merge(headers)
#    end
  end
end
