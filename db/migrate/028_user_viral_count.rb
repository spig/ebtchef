class UserViralCount < ActiveRecord::Migration
  def self.up
    add_column :users, :viral_sent_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :viral_sent_count
  end
end
