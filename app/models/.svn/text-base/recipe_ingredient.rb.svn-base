class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient
  validates_presence_of :recipe_id
  validates_presence_of :ingredient_id
  validates_uniqueness_of :recipe_id, :scope => [:ingredient_id]
  validates_uniqueness_of :ingredient_id, :scope => [:recipe_id]

  acts_as_list :scope => :recipe
  
  validates_inclusion_of :measure,
    :in => %w( envelope envelopes bag bags drop drops cube cubes square squares leaf leaves slice slices can cans cup cups tsp tsps tbsp tbsps Tbsp Tbsps pound pounds lbs lb oz ozs ounce ounces pinch dash package packages pkg pkgs packet ),
    :allow_nil => true,
    :message => 'is not a valid measure.  Please let the Admin know what you were trying to add.'
    
  def before_save
    self.measure = 'Tbsp' if measure == 'tbsp'
    self.measure = 'Tbsps' if measure == 'tbsps'
  end
end
