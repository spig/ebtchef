class WeeklyMealPlan < ActiveRecord::Base
  has_many :meal_plans, :dependent => :destroy

  def self.find_week arg=nil
    find_by_week_number week(arg)
  end

  def self.week arg=nil
    case arg
    when nil
      arg = 2.days.ago.to_date
    when Fixnum
      arg = arg.weeks.from_now - 2.days
    end
    arg.to_date.cweek + (arg.year & 1) * 54
  end
end
