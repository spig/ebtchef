class Admin::AffiliateLogController < Admin::ApplicationController
  layout 'admin'

  include ExceptionNotifiable

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def index
    @affiliate = Affiliate.find(params[:id]) if params[:id]
    if @affiliate
      @affiliate_logs = AffiliateLog.find(:all, :conditions => "affiliate_id = #{@affiliate.id}", :order => 'created_at desc')
    else
      @affiliate_logs = AffiliateLog.find(:all, :order => 'affiliate_id, created_at desc')
    end
  end
end
