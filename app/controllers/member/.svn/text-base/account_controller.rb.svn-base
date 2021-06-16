class Member::AccountController < Member::ApplicationController
  layout 'member'
  
  before_filter :require_ssl

  def index
    @user = User.find_by_id(session[:user_id])
    @user.email_confirmation = @user.email
  end
  
  def confirm
  end
  
  def logout
    redirect_to :controller => '../public', :action => 'logout'
  end
  
  def cancel
    @user = User.find(session[:user_id])
    unless request.get?
      if params[:cancel] =~ /PLEASE SELECT ONE/
        flash.now[:notice] = "Please select a cancel reason"
        return
      else
        if params[:cancel] =~ /Other/
          if params[:cancel_tb] == ""
            flash.now[:notice] = "Please explain why you are canceling."
            return
          end
          @user.cancel_reason = "Other: " + params[:cancel_tb]
        else
          @user.cancel_reason = params[:cancel]
        end
        @user.cancelled_on = Date.today
        @user.send_weekly_reminder = false
      end
      if @user.save
        # show confirmation page then logout
        redirect_to :action => 'confirm'
      end
    end
  end
  
  def update
    @user = User.find(session[:user_id])
    params[:user].delete_if { |key,value| key.match(/password/i) and value.empty? }
    unless params[:user][:recurrence] == @user.recurrence
      case params[:user][:recurrence]
      when 'monthly'
        @user.price = Promo::DefaultMonthlyPrice
      when 'yearly'
        @user.price = Promo::DefaultYearlyPrice
      end
    end
    @user.attributes = params[:user]
    if params[:user][:ccnum] and @user.ccnum != params[:user][:ccnum]
      @user.credit_card_number = params[:user][:ccnum]
      @user.ccnum = params[:user][:ccnum]
      @user.checkacct = nil
    elsif params[:user][:checkacct] and @user.checkacct != params[:user][:checkacct]
      @user.checking_account = params[:user][:checkacct]
      @user.checkacct = params[:user][:checkacct]
      @user.ccnum = nil
    end

    if @user.save
      flash.now[:notice] = "Account Information Updated, Activating Account..."
    else
      flash.now[:notice] = "There was a problem updating your account."      
    end
    render :action => 'index'
  end
  
  def activate_account
    @user = User.find(session[:user_id])
    @user.attributes = params[:user]
    if params[:user][:ccnum] and @user.ccnum != params[:user][:ccnum]
      @user.credit_card_number = params[:user][:ccnum]
      @user.ccnum = params[:user][:ccnum]
      @user.checkacct = nil
    elsif params[:user][:checkacct] and @user.checkacct != params[:user][:checkacct]
      @user.checking_account = params[:user][:checkacct]
      @user.checkacct = params[:user][:checkacct]
      @user.ccnum = nil
    end

    if @user.save
      billing = @user.bill_once
      unless billing.error_msg
        @user.on_hold = false
        @user.failed_notice_count = 0
        if @user.save
          flash.now[:notice] = "Account Information Updated, Activating Account..."
        end
      else
        flash.now[:notice] = "Payment Failed Again: #{billing.error_msg}"
      end
    else
      flash.now[:notice] = "There was a problem updating your account."
    end
    render :action => 'index'
  end

end
