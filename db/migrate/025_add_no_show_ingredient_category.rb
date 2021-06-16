class AddNoShowIngredientCategory < ActiveRecord::Migration
  def self.up
    IngredientCategory.create(:name => 'no display', :id => 103)
  end

  def self.down
    IngredientCategory.destroy(103)
  end
end
