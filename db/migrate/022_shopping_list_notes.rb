class ShoppingListNotes < ActiveRecord::Migration
  def self.up
    add_column :recipe_ingredients, :shopping_notes, :text
  end

  def self.down
    remove_column :recipe_ingredients, :shopping_notes
  end
end