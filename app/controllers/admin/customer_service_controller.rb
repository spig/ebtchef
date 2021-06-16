class Admin::CustomerServiceController < Admin::ApplicationController
  layout 'admin'

  include ExceptionNotifiable
  
  def index
    order_by = params[:order_by] ? params[:order_by] : 'created_at'
    order_by += params[:desc] ? ' ' + params[:desc] : ' desc'
    @desc = params[:desc] == 'desc' ? 'asc' : 'desc'
    if /\s*([^\s]+)\s+([^\s]+)\s*/ =~ params[:search]
      first = User.connection.quote("%#{$1}%")
      last = User.connection.quote("%#{$2}%")
      search_clause = params[:search].blank? ? nil : ' and (first_name like ' + first + ' and last_name like ' + last + ')'
    else
      search = User.connection.quote("%#{params[:search]}%")
      search_clause = params[:search].blank? ? nil : ' and (first_name like ' + search + ' or last_name like ' + search + ' or email like ' + search + ')'
    end
    monthly_section = params[:section] != 'monthly' && params[:section] != 'members' && params[:section] != 'all' ? ' and id = 0' : nil
    yearly_section = params[:section] != 'yearly' && params[:section] != 'members' && params[:section] != 'all' ? ' and id = 0' : nil
    trials_section = params[:section] != 'trials' && params[:section] != 'all' ? ' and id = 0' : nil
    cancelled_section = params[:section] != 'cancelled' && params[:section] != 'all' ? ' and id = 0' : nil
    failed_billings_section = params[:section] != 'failed_billings' && params[:section] != 'all' ? ' and id = 0' : nil
    failed_trials_section = params[:section] != 'failed_trials' && params[:section] != 'all' ? ' and id = 0' : nil
    @monthlies = User.find(:all, :conditions => ["recurrence = 'monthly' and admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and (on_hold = ? or on_hold is null)#{search_clause || monthly_section}", false], :order => order_by).reject{|u| u.free_trial?}
    @monthlies_size = User.find(:all, :conditions => ["recurrence = 'monthly' and admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and (on_hold = ? or on_hold is null)", false], :order => order_by).reject{|u| u.free_trial?}.size
    @yearlies = User.find(:all, :conditions => ["recurrence = 'yearly' and admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and (on_hold = ? or on_hold is null)#{search_clause || yearly_section}", false], :order => order_by).reject{|u| u.free_trial?}
    @yearlies_size = User.find(:all, :conditions => ["recurrence = 'yearly' and admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and (on_hold = ? or on_hold is null)", false], :order => order_by).reject{|u| u.free_trial?}.size
    @trials = User.find(:all, :conditions => "admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and failed_notice_count is null#{search_clause || trials_section}", :order => order_by).select{|u| u.free_trial?}
    @trials_size = User.find(:all, :conditions => "admin = 0 and (cancelled_on is null or cancelled_on = '0000-00-00') and failed_notice_count is null", :order => order_by).select{|u| u.free_trial?}.size
    @cancelled = User.find(:all, :conditions => "cancelled_on is not null and cancelled_on <> '0000-00-00'#{search_clause || cancelled_section}", :order => order_by).reject{|u| u.cancelled_on.nil?}
    @cancelled_size = User.find(:all, :conditions => "cancelled_on is not null and cancelled_on <> '0000-00-00'", :order => order_by).reject{|u| u.cancelled_on.nil?}.size
    @failed_billings = User.find(:all, :conditions => "failed_notice_count > 0 and cancelled_on is null and billing_info is not null#{search_clause || failed_billings_section}")
    @failed_billings_size = User.count(:conditions => "failed_notice_count > 0 and cancelled_on is null and billing_info is not null")
    @failed_trials = User.find(:all, :conditions => "failed_notice_count > 0 and cancelled_on is null and billing_info is null#{search_clause || failed_trials_section}")
    @failed_trials_size = User.count(:conditions => "failed_notice_count > 0 and cancelled_on is null and billing_info is null")
    @all_size = User.count :conditions => 'admin = 0'
  end
  
  def show_cancel
    @user = User.find(params[:id])
    render :action => "cancel"
  rescue => e
    flash[:notice] = "User not found: #{e.message}"
    redirect_to :action => "index"
  end
  
  def cancel
    @user = User.find(params[:id])
    @user.cancel(params[:user])
    flash[:notice] = "User (#{@user.email}) has been cancelled"
    redirect_to :action => 'index'
  rescue => e
    flash[:notice] = "Failure modifying user: #{e.message}"
  end

  def change_password
    @user = User.find(params[:id])
    if (params[:password])
      @user.password = params[:password]
      @user.save!
      flash[:notice] = "User's (#{@user.email}) password has been changed to #{params[:password]}"
      redirect_to :action => 'index'
    end
  rescue => e
    if params[:user]
      flash[:notice] = "Error updating user's password: #{e.message}"
    else
      flash[:notice] = "User not found: #{e.message}"
    end
    redirect_to :action => "index"
  end
  
end
