class AddUserRecurrenceField < ActiveRecord::Migration
  def self.up
    add_column :users, :recurrence, :string, :default => 'monthly'
  end

  def self.down
    remove_column :users, :recurrence
  end
end
