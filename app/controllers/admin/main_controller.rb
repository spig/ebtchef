class Admin::MainController < Admin::ApplicationController
  layout 'admin'#, :except => :not_admin

  include ExceptionNotifiable


  def not_admin
    @ipaddr = request.remote_ip
  end
  
  def index
    @user = nil
    @user = User.find(session[:user_id]) if session[:user_id]
    @todays_users = User.find(:all, :conditions => ['created_at >= ?',
        Time.now.beginning_of_day])
    @this_weeks_users = User.find(:all, :conditions => ['created_at >= ?',
        Time.now.beginning_of_week])
    @last_weeks_users = User.find(:all, :conditions => ['created_at between ? and ?',
        1.week.ago.beginning_of_week, Time.now.beginning_of_week])
    @prev_weeks_users = User.find(:all, :conditions => ['created_at between ? and ?',
        2.week.ago.beginning_of_week, 1.week.ago.beginning_of_week])
    @months_users = User.find(:all, :conditions => ['created_at >= ?',
        Time.now.beginning_of_month])
    @last_months_users = User.find(:all, :conditions => ['created_at between ? and ?',
        Time.now.months_ago(1).beginning_of_month, Time.now.beginning_of_month])

#    @todays_conversions = User.find(:all, :conditions => ['created_at between ? and ? and last_billed_on is not null',
#        14.days.ago.beginning_of_day, 13.days.ago.beginning_of_day])
#    @todays_total = User.count(:conditions => ['created_at between ? and ?',
#        14.days.ago.beginning_of_day, 13.days.ago.beginning_of_day])
#    @todays_percent = (@todays_conversions.size * 100.0/(@todays_total == 0 ? 1 : @todays_total)).to_s 1

    @this_weeks_conversions = User.find(:all, :conditions => ['created_at between ? and ? and last_billed_on is not null',
        2.weeks.ago.beginning_of_week, 1.weeks.ago.beginning_of_week])
    @this_weeks_total = User.count(:conditions => ['created_at between ? and ?',
        2.weeks.ago.beginning_of_week, 1.weeks.ago.beginning_of_week])
    @this_weeks_percent = (@this_weeks_conversions.size * 100.0/(@this_weeks_total == 0 ? 1 : @this_weeks_total)).to_s 1

    @last_weeks_conversions = User.find(:all, :conditions => ['created_at between ? and ? and last_billed_on is not null',
        3.weeks.ago.beginning_of_week, 2.weeks.ago.beginning_of_week])
    @last_weeks_total = User.count(:conditions => ['created_at between ? and ?',
        3.weeks.ago.beginning_of_week, 2.weeks.ago.beginning_of_week])
    @last_weeks_percent = (@last_weeks_conversions.size * 100.0/(@last_weeks_total == 0 ? 1 : @last_weeks_total)).to_s 1

    @prev_weeks_conversions = User.find(:all, :conditions => ['created_at between ? and ? and last_billed_on is not null',
        4.weeks.ago.beginning_of_week, 3.weeks.ago.beginning_of_week])
    @prev_weeks_total = User.count(:conditions => ['created_at between ? and ?',
        4.weeks.ago.beginning_of_week, 3.weeks.ago.beginning_of_week])
    @prev_weeks_percent = (@prev_weeks_conversions.size * 100.0/(@prev_weeks_total == 0 ? 1 : @prev_weeks_total)).to_s 1

    @last_months_name = []
    @last_months_conversions = []
    @last_months_total = []
    @last_months_percent = []
    (0..12).each do |month|
      month_mid = Time.now.months_ago(month)
      month_start = month_mid.beginning_of_month - 2.weeks
      month_end = month_mid.months_since(1).beginning_of_month - 2.weeks
      @last_months_name[month] = month_mid.strftime '%B %Y'
      @last_months_conversions[month] = User.find(:all,
          :conditions => ['created_at between ? and ? and last_billed_on is not null',
          month_start, month_end])
      @last_months_total[month] = User.count(:conditions => ['created_at between ? and ?',
          month_start, month_end])
      @last_months_percent[month] = (@last_months_conversions[month].size * 100.0/(@last_months_total[month] == 0 ? 1 : @last_months_total[month])).to_s 1

      # Calculate averages
      @start_date = Date.new(2007, 4, 1)
      users = User.find :all, :conditions=>['created_at >= ? and last_billed_on is not null', @start_date]
      time = 0
      paid = 0.0
      users.each do |user|
        cancelled = user.cancelled_on || Date.today
        days = cancelled - user.created_at.to_date
        time += days
        paid += case user.recurrence
        when 'monthly'
          months = (days / 30.4375).floor + 1
          user.price * months
        when 'yearly'
          years = (days / 365.25).floor + 1
          user.price * years
        end
      end
      total_users = User.count :conditions=>['created_at >= ?', @start_date]
      total_months = (Date.today - @start_date) / 30.4375
      average_months = time / users.size / 30.4375
      @average_months = sprintf '%#.1f', average_months
      @average_members = sprintf '%#.1f', users.size * average_months / total_months
      @average_user_revenue = sprintf '$%#.2f', paid * 0.01 / users.size
      @average_month_revenue = sprintf '$%#.2f', paid * 0.01 / total_months
      @average_conversions = sprintf '%#.1f%', users.size * 100.0 / total_users

      nocc_date = Date.new 2008, 3, 25
      @total_nocc_trials = User.count :conditions=>['created_at >= ?', nocc_date]
      @total_nocc_conversions = User.count :conditions=>['created_at >= ? and billing_info is not null', nocc_date]
      @percent_nocc_conversions = sprintf '%#.1f%', @total_nocc_conversions * 100.0 / @total_nocc_trials
    end

  end

end

class Float
  alias_method :orig_to_s, :to_s
  def to_s(arg = nil)
    if arg.nil?
      orig_to_s
    else
      sprintf("%.#{arg}f", self)
    end
  end
end
