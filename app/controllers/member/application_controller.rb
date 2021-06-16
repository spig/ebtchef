class Member::ApplicationController < ApplicationController
  before_filter :authorize, :account_status
  
  private
  def authorize
    if session[:user_id]
      next_wednesday_at_midnight = Ebtchef::DateCalculation.days_to_next_wednesday.days.since.midnight
      cookies['weekly_meal_plan'] ||= { :value => CustomWeekMealPlan.gen_cookie, :expires => next_wednesday_at_midnight }
      begin
        unless cookies['logged_in']
          user = User.find(session[:user_id])
          UserLog.create(:user_id => user.id, :ip_addr => request.remote_ip)
          user.last_login_at = Time.now()
          user.save
        end
        cookies['logged_in'] = { :value => 'true', :expires => 30.minutes.from_now }
		@logged_in = true
      rescue => e
        # catch any errors and report them to the log
        logger.info "EXCEPTION CAUGHT in #{__FILE__} at line #{__LINE__}\n#{e.message}"
      end
    else
      session[:original_uri] = request.request_uri
      redirect_to :controller => '/public', :action => 'index'
      return false
    end
    true
  end
  
  def account_status
    if session[:user_id] && (params[:controller] =~ /account/).nil?
      user = User.find_by_id(session[:user_id])
      if user.on_hold
        flash[:error] = "Please update your billing information"
        redirect_to :controller => "account"
        return false
      end
    end
    true
  end
  
end
