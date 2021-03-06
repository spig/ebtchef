# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] = RAILS_ENV = 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '1.1.6'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # Only keep 50 log files of 1MB each
  config.logger = Logger.new(config.log_path, 50, 1048576)
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
require 'payment/echo_net'
require 'sentry'
require 'ebtchef/date_calculation'
require 'ar_extensions'
require 'fraction_to_float'
require 'stringio'

$view_visit_count = Hash.new
$layout_visit_count = Hash.new
$chef = "direct" # affiliate_id for direct chef signups
$encrypter = Sentry::AsymmetricSentry.new(:public_key_file => "#{RAILS_ROOT}/lib/public_billing.key")

ExceptionNotifier.sender_address = $EN_sender_address
ExceptionNotifier.email_prefix = $EN_email_prefix
ExceptionNotifier.exception_recipients = $EN_exception_recipients

# Ruby 1.8.6+ and 1.9 define private Time#to_date
class Time
  %w(to_date to_datetime).each do |method|
    public method if private_instance_methods.include?(method)
  end
end
