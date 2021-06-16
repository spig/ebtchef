class MealPlanRecipe < ActiveRecord::Base
  belongs_to :meal_plan
  belongs_to :recipe
  validates_presence_of :recipe_id
  validates_presence_of :meal_plan_id
  validates_uniqueness_of :recipe_id, :scope => [:meal_plan_id]
  validates_uniqueness_of :meal_plan_id, :scope => [:recipe_id]
  
  acts_as_list :scope => :meal_plan
end
