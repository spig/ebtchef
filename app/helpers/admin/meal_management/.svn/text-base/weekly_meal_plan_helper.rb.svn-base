module Admin::MealManagement::WeeklyMealPlanHelper
  
  def current_week_number
    #(Time.now - 2.days).to_date.cweek + @week.to_i + 1
    WeeklyMealPlan.week @week.to_i + 1
  end
  
  def current_week
    week_num = @week.to_i + 1
    ((week_num.weeks.from_now - 2.days).beginning_of_week + 2.days).strftime("%B %d, %Y")
  end
  
  def get_previous_week
    @week.to_i - 1
  end
  
  def get_next_week
    @week.to_i + 1
  end
  
  def get_previous_month
    @week.to_i - 4
  end
  
  def get_next_month
    @week.to_i + 4
  end

end
