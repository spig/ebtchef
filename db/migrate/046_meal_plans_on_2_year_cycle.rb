class MealPlansOn2YearCycle < ActiveRecord::Migration
  def self.up
    weeks = []
    (54..106).each do |week|
      weeks[week - 53] = WeeklyMealPlan.create(:week_number => week)
    end
    this_week = WeeklyMealPlan.week Date.new(2008, 4, 23)
    MealPlan.find(:all, :include=>:weekly_meal_plan, :conditions=>['week_number > ?', this_week]).each do |plan|
      plan.weekly_meal_plan = weeks[plan.weekly_meal_plan.week_number]
      plan.save
    end
    WeeklyMealPlan.find(:all, :conditions=>'not exists (select id from meal_plans where weekly_meal_plan_id = weekly_meal_plans.id)').each do |mp|
      MealPlan.create(:name => 'meal1', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal2', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal3', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal4', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal5', :weekly_meal_plan_id => mp.id)
    end
  end

  def self.down
    MealPlan.find(:all, :include=>:weekly_meal_plan, :conditions=>'week_number > 53').each do |plan|
      plan.destroy if MealPlan.find :first, :include=>:weekly_meal_plan, :conditions=>['week_number = ?', plan.weekly_meal_plan.week_number]
    end
    MealPlan.find(:all, :include=>:weekly_meal_plan, :conditions=>'week_number > 53').each do |plan|
      plan.weekly_meal_plan = WeeklyMealPlan.find :first, :conditions=>['week_number = ?', plan.weekly_meal_plan.week_number - 53]
      plan.save
    end
    WeeklyMealPlan.find(:all, :conditions=>'week_number > 53').each do |plan|
      plan.destroy
    end
  end
end
