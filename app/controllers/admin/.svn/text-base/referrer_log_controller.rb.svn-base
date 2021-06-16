class Admin::ReferrerLogController < Admin::ApplicationController
  layout 'admin'

  include ExceptionNotifiable

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def index
    @referrer = Referrer.find(params[:id]) if params[:id]
    if @referrer
      @referrer_logs = ReferrerLog.find(:all, :conditions => "referrer_id = #{@referrer.id}", :order => 'created_at desc', :group => 'date_format(created_at, "%Y%m%d %H%M"), ip_addr')
    else
      @referrer_logs = ReferrerLog.find(:all, :order => 'ip_addr, created_at desc')
    end
  end
end
