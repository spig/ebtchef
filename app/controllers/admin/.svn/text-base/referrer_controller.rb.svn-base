class Admin::ReferrerController < Admin::ApplicationController
  layout 'admin'

  include ExceptionNotifiable

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

  def index
    @referrers = Referrer.find(:all, :order => 'host')
  end

end
