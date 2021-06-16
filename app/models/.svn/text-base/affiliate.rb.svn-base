class Affiliate < ActiveRecord::Base
  has_many :affiliate_logs
  
  validates_uniqueness_of :name
  
  attr_reader :campaign_url, :referral_url
  
  def campaign_url request, campaign, email=nil
    referral_url(request, email) + "&utm_campaign=#{campaign}"
  end
  
  def referral_url request, email=nil
    "http://#{request.host_with_port}/public/index?affid=#{name}&utm_source=#{name}" + (email.nil? ? '' : "&utm_medium=email")
  end
  
  def signup_url request
    "https://#{request.host_with_port}/public/signup?affid=#{name}&utm_source=#{name}"
  end
end