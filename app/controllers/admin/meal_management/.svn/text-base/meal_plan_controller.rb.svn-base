class Admin::MealManagement::MealPlanController < Admin::MealManagement::ApplicationController
  layout 'admin'

  verify :method => :post, :only => :remove_recipe
  
  def new
    @meal_plan ||= MealPlan.new
    @meal_plan_id = params[:meal_plan_id]
  end
  
  def create
    wmp = WeeklyMealPlan.find(params[:meal_plan_id])
    wmp.meal_plans << MealPlan.create(params[:meal_plan])
    
    redirect_to :controller => 'weekly_meal_plan'
  end
  
  def remove_recipe
    MealPlanRecipe.find_by_meal_plan_id_and_recipe_id(params[:id], params[:recipe_id]).destroy
    redirect_to :controller => 'weekly_meal_plan', :week => params[:week]
  end

  def edit
    @week = params[:week].to_i
    @meal_plan = MealPlan.find(params[:id])
  end
  
  def update
    @meal_plan = MealPlan.find(params[:id])
    @meal_plan.update_attributes(params[:meal_plan])
    @meal_plan.save
    redirect_to :controller => 'weekly_meal_plan', :week => params[:week]
  end
  
end
