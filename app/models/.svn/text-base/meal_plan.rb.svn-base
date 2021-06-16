class MealPlan < ActiveRecord::Base
  belongs_to :weekly_meal_plan
  belongs_to :meal_plan_type
  has_many :recipes, :through => :meal_plan_recipes, :uniq => true, :order => 'meal_plan_recipes.position'
  has_many :meal_plan_recipes, :dependent => :destroy, :order => "position"
end
