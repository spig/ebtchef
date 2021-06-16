class Admin::AffiliateController < Admin::ApplicationController
  layout 'admin'
  before_filter :authorize_admin
  
  def index
    @affiliates = Affiliate.find(:all)
  end
  
  def create
    # raise params[:affiliate][:contact_first_name]
    user = User.new
    user.first_name = params[:affiliate][:contact_first_name]
    user.last_name = params[:affiliate][:contact_last_name]
    user.address = params[:affiliate][:contact_addredd]
    user.city = params[:affiliate][:contact_city]
    user.state = params[:affiliate][:contact_state]
    user.zip = params[:affiliate][:contact_zip]
    user.email = params[:affiliate][:contact_email]
    user.user_name = params[:affiliate][:name]
    user.hash_password = params[:affiliate][:password]
    user.is_affiliate = true
    
    affiliate = Affiliate.new(:name => params[:affiliate][:name], :created_on => Time.now())
    promo = Promo.new(:name => params[:affiliate][:name], :price => params[:affiliate][:promo_price], :days_to_first_billing => params[:affiliate][:days_to_first_billing])
    
    if user.save
    
      affiliate.save
      promo.save
      flash[:notice] = "Affiliate successfully added."
    else
      raise user.errors.full_messages.join("\n").to_s
      flash[:notice] = "There was a problem"      
    end
    
  render :action => 'index'
  end

def summary
  # This is a summary of stats per affiliate
  @affiliate = Affiliate.find(:first, :conditions => [ "name = (?)", @user.user_name])
  @cancellations = User.count(:all, :conditions => ["cancelled_on is not null and affiliate_id = (?)",@user.user_name])
end


private



end
