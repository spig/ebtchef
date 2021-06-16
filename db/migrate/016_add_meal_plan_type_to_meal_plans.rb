class AddMealPlanTypeToMealPlans < ActiveRecord::Migration
  def self.up
    add_column :meal_plans, :meal_plan_type_id, :integer
  end

  def self.down
    remove_column :meal_plans, :meal_plan_type_id
  end
end