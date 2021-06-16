class RenameNewsletterColumn < ActiveRecord::Migration
  def self.up
    rename_column :newsletters, :availible_on, :available_on
  end

  def self.down
    rename_column :newsletters, :available_on, :availible_on
  end
end
