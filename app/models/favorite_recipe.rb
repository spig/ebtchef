class FavoriteRecipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe
  
  validates_uniqueness_of :user_id, :scope => :recipe_id
  validates_uniqueness_of :recipe_id, :scope => :user_id
end
