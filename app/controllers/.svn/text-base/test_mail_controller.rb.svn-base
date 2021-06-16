class TestMailController < ApplicationController

  def index
    # test url with google tracking metrics
    # http://ebtchef.com/?affid=cathexis&utm_source=cathexis&utm_medium=email&utm_campaign=060921
    @user = User.new
    @user.first_name = 'John'
    @user.last_name = 'Doe'
    @user.email = "wpvoll@gmail.com"
    @user.id = 458
    @user.last_billed_on = DateTime.now
    @user.price = 495
    @email_id = Email.new.id
    @utm_medium = 'email'
    @utm_campaign = "email_#{@email_id}"
    @utm_source = 'weekly_reminder_email'
    @day_of = params["day_of"] ? params["day_of"].to_i : 28
    @order_id = "2323"
    @referrer = User.find_by_id(152)
    @referred = User.new
    @referred.first_name = "Sally"
    @referred.last_name = "Burningham"
    
    @letter = Newsletter.find(:first, :order => 'available_on desc')
    
    # render :text => "just link the template to the file you want to show - found in app/controllers/testmailcontroller - then add an email to test email loads against"
    # render :template => 'notifications/weekly.text.html.rhtml'
    # render :template => 'notifications/weekly_nonsub.text.html.rhtml'
    # render :template => 'notifications/welcome_free14_email.text.html.rhtml'
    # render :template => 'notifications/welcome_email.text.html.rhtml'
    # render :template => 'notifications/member_referral_signed_up.text.html.rhtml'
    # render :template => 'public/thank_you.rhtml'
    # render :template => 'notifications/jeff_personal_sell.text.html.rhtml'
    # render :template => 'notifications/jeff_personal_sell_non_sub.text.html.rhtml'
    # render :template => 'billing_expiring.rhtml'
    #render :template => 'notifications/billing_failed.text.html.rhtml'
    render :template => 'notifications/trial_day16.text.html.rhtml'
    # render :template => 'notifications/test_weekly.rhtml'
    # render :template => 'notifications/test_weekly_nonsub.rhtml'
    #render :template => 'notifications/test_jeff_personal_sell.rhtml'
    #render :template => 'notifications/test_member_launch'
    #render :template => 'notifications/test_survey_respondents'
    #render :template => 'notifications/test_newsletter_subscribers_launch'
    #render :template => 'notifications/test_welcome_email'
    #render :template => 'notifications/test_welcome_free30_email'
  end
  
end
