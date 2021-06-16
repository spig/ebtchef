# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false
$EN_sender_address = 'web-errors@ebtchef.com'
$EN_email_prefix = '[CHEF-PROD-ERR] '
# $EN_exception_recipients = %w(web-errors@ebtchef.com)
$EN_exception_recipients = %w(troyhen@gmail.com)

$ECHO_MERCHANT_ID = '801>3584517'
# $ECHO_MERCHANT_PIN = '03291977'
# $ECHO_MERCHANT_PIN = '48909246' # new pin as of 2/2/2007
$ECHO_MERCHANT_PIN = '22303400' # new pin as of 12/10/2008