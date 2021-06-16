class OrderMealPlanRecipes < ActiveRecord::Migration
  def self.up
    add_column :meal_plan_recipes, :position, :integer
  end

  def self.down
    remove_column :meal_plan_recipes, :position
  end
end
