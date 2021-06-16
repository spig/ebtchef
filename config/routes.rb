ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
 
  map.email_tracker_newsletter 'etn', :controller => 'email_tracker', :action => 'track_email_opens'
  map.email_tracker_member 'etm', :controller => 'email_tracker', :action => 'track_email_opens'
  map.email_tracker 'et', :controller => 'email_tracker', :action => 'track_email_opens'
  map.email_click_through 'ect', :controller => 'email_tracker', :action => 'track_email_click_throughs'
  map.unsubscribe 'unsubscribe', :controller => 'email_tracker', :action => 'unsubscribe'

  map.admin 'admin/meal_management', :controller => 'admin/meal_management/application'
  map.admin 'admin', :controller => "admin/main", :action => 'index'

  # map.admin 'admin/login', :controller => 'admin/login', :action => 'login'
  map.member 'member', :controller => 'member/main', :action => 'weekly_meal_plans'
  map.member_login 'public', :controller => 'public' #changed to member _login because login is being used for admin/affiliate login
  map.signup 'signup', :protocol => RAILS_ENV.match(/development/) ? 'http://' : 'https://', :controller => 'public', :action => 'signup'
  map.signup 'signup/referrer', :protocol => RAILS_ENV.match(/development/) ? 'http://' : 'https://', :controller => 'public', :action => 'referrer_signup'
  
  map.with_options :controller => 'admin/tools' do |c|
    c.admin_tools 'admin/tools', :action => 'index'
    c.admin_tools_clear_sessions 'admin/tools/clear_sessions', :action => 'clear_sessions'
    
  end
  map.with_options :controller => 'admin/newsletters' do |c|
    c.admin_newsletters 'admin/newsletters', :action => 'list'
    c.admin_newsletters_new 'admin/newsletters/new', :action => 'new'
  end
    
  map.with_options :controller => "admin/affiliate" do |c|
    c.affiliate 'affiliate', :action => 'summary'
  end
  
  map.with_options :controller => 'admin/login' do |c|
    c.login 'login', :action=> 'login'
    c.logout 'logout', :action=> 'logout'
  end
  
  map.with_options :controller => 'public' do |c|
    c.logout 'logout', :action => 'logout'
  end
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
