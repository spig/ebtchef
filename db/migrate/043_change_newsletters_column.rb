class ChangeNewslettersColumn < ActiveRecord::Migration
  def self.up
    rename_column :newsletters,:treat_ingreidents, :treat_ingredients
  end

  def self.down
  end
end
