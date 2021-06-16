class ExtendRecipeInstructionsNotesFields < ActiveRecord::Migration
  def self.up
    change_column :recipes, :instructions, :text
    change_column :recipes, :notes, :text
  end

  def self.down
    change_column :recipes, :instructions, :string
    change_column :recipes, :notes, :string
  end
end
