class Admin::MealManagement::WeeklyMealPlanController < Admin::ApplicationController
  layout 'admin'

  auto_complete_for :recipe, :name
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @week = params[:week].to_i
    week_number = @week + 1
    #@weekly_meal_plan = WeeklyMealPlan.find_by_week_number((week_number.weeks.from_now-2.days).to_date.cweek)
    @weekly_meal_plan = WeeklyMealPlan.find_week week_number
  end

  private

  def get_week_number_of_today
  end
  
end
