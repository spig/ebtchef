class Admin::ApplicationController < ApplicationController

  prepend_before_filter :authorize
  before_filter :require_ssl

private

  def authorize
    @user = nil
    @user = User.find(session[:user_id]) if session[:user_id]
    #redirect_to :action => 'not_admin' unless user and user.admin?
    if @user && (@user.admin? || @user.is_affiliate)
      return true
    end
    render(:file => File.dirname(__FILE__) + '/../../../public/404.html', :status => 404) # TODO - Not sure this is the best way to handle unauthorized admin/affiliates
    false
  end
  
  def authorize_admin
    @user = nil
    @user = User.find(session[:user_id]) if session[:user_id]
    unless @user.admin?
      if @user.is_affiliate?
        summary
        return false
      end
    end
    true
  end

end
