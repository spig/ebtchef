# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  session :session_expires => 365.days.from_now
  prepend_before_filter :set_tracking_data, :redirect_www, :load_cookies
  
  def set_tracking_data
    
    ref_id = params[:referrer_id] || params[:ref_id]
    referrer = request.env['HTTP_REFERER'] unless request.env['HTTP_REFERER'].to_s.match(/^http[s]?:\/\/(www\.)?ebtchef.com/)
    affiliate_id = params[:affid] || params[:affiliate_id]
    if affiliate_id.to_s.empty?
      affiliate_id = $chef
    end
    sub_affiliate_id = params[:sub_affiliate_id]
    
    cookies['sub_affid'] = sub_affiliate_id unless sub_affiliate_id.to_s.empty?
    cookies['rmid'] = ref_id unless ref_id.to_s.empty?
    cookies['ref'] = referrer unless referrer.to_s.empty?
    cookies['affid'] = affiliate_id unless affiliate_id.to_s.empty?

    unless ref_id.to_s.empty?
      user = User.find(ref_id)
      ReferralLog.create(:user_id => user.id, :ip_addr => request.remote_ip) if user and unique_visit
    end
    
    unless affiliate_id.to_s.empty? or user
      affiliate = Affiliate.find(:first, :conditions => ['name = ?', affiliate_id])
      AffiliateLog.create(:affiliate_id => affiliate.id, :ip_addr => request.remote_ip) if affiliate and unique_visit
    end
    
    unless referrer.to_s.empty?
      logger.debug "referrer = #{referrer}"
      uri = URI.parse(referrer)
      r = Referrer.find_or_create_by_host(uri.host)
      ReferrerLog.create(:referrer_id => r.id, :ip_addr => request.remote_ip, :uri => referrer) if r and unique_visit
    end
    true
  rescue => e
    logger.info "EXCEPTION CAUGHT in #{__FILE__} at line #{__LINE__}\n#{e.message}"
    true
  end
  
  def unique_visit
    return false if cookies['rmid'] or cookies['ref'] or cookies['affid']
    return true
  end

  def rescue_action_in_public(exception)
    case exception
      when Payment::PaymentError
        render(:file => "#{RAILS_ROOT}/public/404.html", :status => "404 Error")
      else
        render(:file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
    end
  end
  
  protected

  def require_ssl
    if !@request.ssl? && RAILS_ENV == 'production'
      redirect_to :protocol => "https://"
      return false
    end
    true
  end
  
  def load_cookies
	@logged_in = (cookies['logged_in'] == 'true')
	true
  end

  def redirect_www
    begin
      reset_session
      render :text => %Q|<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
      	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

      <html xmlns="http://www.w3.org/1999/xhtml" version="-//W3C//DTD XHTML 1.1//EN" xml:lang="en">
      <head>
        <script language="javascript">
          window.location.href = "#{request.protocol + 'ebtchef.com' + request.request_uri}";
        </script>
      	<title>Everything but the Chef</title>
      </head>
      <body>
      You should be redirected to the new URL for Everything but the Chef.<br />
      <br />
      Please use <a href="#{request.protocol + 'ebtchef.com' + request.request_uri}">this url</a> to continue on and if you still have difficulties please go to <a href="http://ebtchef.com/">http://ebtchef.com/</a>
      </body>
      </html>|
      return false
    end if request.host.nil? or request.host.match(/\.ebtchef\.com/)
    true
  end
end

