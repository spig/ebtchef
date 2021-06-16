# Author::    Steve Spigarelli (mailto:spig@spig.net)
# Copyright:: Copyright (c) 2006 Steve Spigarelli
# License::   Distributes under the same terms as Ruby

require 'cgi'
require 'csv'

require 'payment/base'

module Payment

class EchoNet < Base
  attr_accessor :transaction_type, :order_type, :billing_ip_address
  attr_accessor :billing_phone, :merchant_echo_id, :merchant_pin, :isp_echo_id
  attr_accessor :isp_pin, :authorization, :billing_prefix
  attr_accessor :billing_first_name, :billing_last_name, :billing_company_name
  attr_accessor :billing_address1, :billing_address2, :billing_city, :billing_state
  attr_accessor :billing_zip, :billing_country, :billing_phone, :billing_fax, :billing_email
  attr_accessor :cc_number, :ccexp_month, :ccexp_year, :cnp_recurring, :cnp_security
  attr_accessor :counter, :debug, :ec_account, :ec_account_type, :ec_address1, :ec_address2
  attr_accessor :ec_bank_name, :ec_city, :ec_email, :ec_first_name, :ec_id_country
  attr_accessor :ec_id_exp_mm, :ec_id_exp_dd, :ec_id_exp_yy, :ec_id_number, :ec_id_state, :ec_id_type
  attr_accessor :ec_last_name, :ec_business_name, :ec_other_name, :ec_payee, :ec_payment_type
  attr_accessor :ec_rt, :ec_serial_number, :ec_state, :ec_transaction_dt, :ec_zip, :eci, :grand_total
  attr_accessor :merchant_trace_nbr, :order_number, :original_amount, :original_trandate_mm
  attr_accessor :original_trandate_dd, :original_trandate_yyyy, :original_reference, :product_description
  attr_accessor :purchase_order_number, :sales_tax, :track1, :track2, :xid

  def initialize(options = {})
    # set some sensible defaults
    @url = 'https://wwws.echo-inc.com/scripts/INR200.EXE'
    order_type = 'S'
    counter = '1'
    ec_transaction_dt = Time.now().strftime("%Y%m%d%H%M%S");
    ec_serial_number = 9001;
    
    # include all provided data
    super options
  end
  
  # Submit the order to be processed. If it is not fulfilled for any reason
  # this method will raise an exception.
  # This field identifies the type of transaction being submitted. Valid transaction types are:
  # Credit Card Transactions
  # AD (Address Verification)
  # AS (Authorization)
  # AV (Authorization with Address Verification)
  # CR (Credit)
  # DS (Deposit)
  # ES (Authorization and Deposit)
  # EV (Authorization and Deposit with Address Verification)
  # CK (System check)
  # 
  # Electronic Check Transactions See Notes.
  # DV (Electronic Check Verification)
  # DD (Electronic Check Debit with Verification)
  # DH (Electronic Check Debit ACH Only)
  # DC (Electronic Check Credit)
  # VD (Void Check)
  # UV (Unvoid Check)
  # QR (Check Query)
  def submit type
    @required = [:transaction_type, :order_type, :merchant_echo_id, :merchant_pin, :billing_ip_address, :counter, :grand_total]
    case type
    when 'AD','AS','AV','CR','DS','ES','EV','CK'
      @required += [:billing_first_name, :billing_last_name, :billing_address1, :billing_city, :billing_state, :cc_number, :ccexp_month, :ccexp_year]
    when 'DV','DD','DH','DC'
      @required += [:ec_first_name, :ec_last_name, :ec_address1, :ec_city, :ec_state, :ec_account, :ec_rt, :ec_email, :ec_transaction_dt, :ec_serial_number]
    else
      raise PaymentError, "Failure 9001"
    end
    set_post_data
    get_response @url
    parse_response
  end
  
  private

  def parse_response
    # fields to populate are :error_code, :error_message, :authorization, :result_code
    @result_code = @response.plain.match(/<status>([^<]+)<\/status/)[1] if @response.plain.match(/status/)
    @error_code = @response.plain.match(/<decline_code>([^<]+)<\/decline_code/)[1] if @response.plain.match(/decline_code/)

    case @result_code
    when 'G'
    else
      raise PaymentError, "Failure #{@error_code}"
    end

    true
  end 
  
  def set_post_data
    prepare_data

    post_array = Array.new
    FIELDS.each do |field|
      value = eval "CGI.escape(#{field}.to_s)"
      post_array << "#{field.to_s}=#{value}" unless value.empty?
    end

    @data = post_array.join('&')
    puts @data.inspect
  end

  # make sensible changes to data
  def prepare_data
    @cc_number = @cc_number.to_s.gsub(/[^\d]/, "") unless @cc_number.nil?
    
    # convert the action
    raise PaymentError, "Failure 9000" unless TYPES.include?(transaction_type)
    
    @required.uniq!
  end

  # map the instance variable names to the gateway's requested variable names
  FIELDS = [:transaction_type, :order_type, :billing_ip_address,
    :billing_phone, :merchant_echo_id, :merchant_pin, :isp_echo_id,
    :isp_pin, :authorization, :billing_prefix,
    :billing_first_name, :billing_last_name, :billing_company_name,
    :billing_address1, :billing_address2, :billing_city, :billing_state,
    :billing_zip, :billing_country, :billing_phone, :billing_fax, :billing_email,
    :cc_number, :ccexp_month, :ccexp_year, :cnp_recurring, :cnp_security,
    :counter, :debug, :ec_account, :ec_account_type, :ec_address1, :ec_address2,
    :ec_bank_name, :ec_city, :ec_email, :ec_first_name, :ec_id_country,
    :ec_id_exp_mm, :ec_id_exp_dd, :ec_id_exp_yy, :ec_id_number, :ec_id_state, :ec_id_type,
    :ec_last_name, :ec_business_name, :ec_other_name, :ec_payee, :ec_payment_type,
    :ec_rt, :ec_serial_number, :ec_state, :ec_transaction_dt, :ec_zip, :eci, :grand_total,
    :merchant_trace_nbr, :order_number, :original_amount, :original_trandate_mm,
    :original_trandate_dd, :original_trandate_yyyy, :original_reference, :product_description,
    :purchase_order_number, :sales_tax, :track1, :track2, :xid]

  # map the types to the merchant's action names
  TYPES = [ 'EV', 'DD', 'AV', 'DV' ]

end

end
