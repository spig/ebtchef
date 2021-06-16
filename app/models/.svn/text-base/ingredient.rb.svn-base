class Ingredient < ActiveRecord::Base
  has_many :recipes, :through => :recipe_ingredient
  has_many :recipe_ingredients, :dependent => :destroy
  belongs_to :ingredient_category
  
  validates_uniqueness_of :name
  validates_presence_of :name
end
