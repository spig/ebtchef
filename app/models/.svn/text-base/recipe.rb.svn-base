class Recipe < ActiveRecord::Base
  has_many :meals, :through => :meal_recipes, :uniq => true
  has_many :meal_plan_recipes, :dependent => :destroy
  has_many :ingredients, :through => :recipe_ingredients, :uniq => true
  has_many :recipe_ingredients, :dependent => :destroy, :uniq => true, :order => 'position'
  has_many :favorite_recipes, :dependent => :destroy, :uniq => true
  has_many :users, :through => :favorite_recipes, :uniq => true
  
  validates_uniqueness_of :name
end
