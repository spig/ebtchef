class ModelsAsLists < ActiveRecord::Migration
  def self.up
    add_column :recipe_ingredients, :position, :integer
  end

  def self.down
    remove_column :recipe_ingredients, :position
  end
end
