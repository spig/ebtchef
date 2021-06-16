class IngredientCategory < ActiveRecord::Base
  MAX_DISPLAYABLE_CATEGORY = 100 # this is hardcoded in the database - below 100 should show, above should not
  PANTRY_CATEGORY = 99
  SEPARATOR_CATEGORY = 102
  NO_SHOW = 103 # for things like water or ubiquitous things - not often used

  DAIRY_FROZEN_CATEGORY = 1
  PRODUCE_CATEGORY = 2
  MEAT_SEAFOOD_CATEGORY = 3
  GRAINS_NUTS_SEEDS_CATEGORY = 4
  CANNED_JAR_CATEGORY = 5
  MISCELLANEOUS_CATEGORY = 6
  
  has_many :ingredients
  
  def self.filter ingredients, ingredient_category
    ings = Hash.new
    ingredients.select { |i| i.ingredient.ingredient_category_id == ingredient_category }.each do |ing|
      ing_name = ing.ingredient.name.to_s
      ing_key = (ing_name+ing.measure.to_s).hash
      ings[ing_key] ||= Hash.new
      ings[ing_key][:name] = ing_name
      ings[ing_key][:quantity] = ings[ing_key][:quantity].to_f + FractionToFloat.new(ing.quantity).to_f
      ings[ing_key][:measure] = ing.measure
      ings[ing_key][:notes] = ing.notes
      ings[ing_key][:shopping_notes] = ing.shopping_notes
    end
    ings
  end
  
end
