class AddPrintableRecipeIngredients < ActiveRecord::Migration
  def self.up
    IngredientCategory.create(:name => 'separator')
    add_column :meal_plans, :note_tip, :string
  end

  def self.down
    IngredientCategory.find_by_name('separator').destroy()
    remove_column :meal_plans, :note_tip
  end
end
