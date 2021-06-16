class Admin::LoginController < ApplicationController
  
  #login admins and affiliates
  layout 'login'

    # Display the login form and wait for user to
    # enter a name and password. We then validate
    # these, adding the user object to the session
    # if they authorize.
    def login
      if request.get?
        session[:user_id] = nil
        @user = User.new
      else
        @user = User.login(params[:user][:user_name], params[:user][:password])
        if @user
          session[:user_id] = @user.id
          if @user.is_affiliate?
            redirect_to(affiliate_url)
          elsif @user.admin?
            redirect_to(admin_url)
          end
        else
          flash[:notice] = "Invalid user/password combination"
        end
      end
    end

    # Log out by clearing the user entry in the session. We then
    # redirect to the #login action.
    def logout
      session[:user_id] = nil
      flash[:notice] = "Logged out"
      redirect_to login_url
    end
  
end
