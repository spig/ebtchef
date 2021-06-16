class AddTrackingStats < ActiveRecord::Migration
  def self.up
    add_column :users, :referrer, :string
    add_column :users, :affiliate_id, :string
    add_column :users, :cancel_date, :date
    add_column :users, :cancel_reason, :string
    add_column :users, :send_weekly_reminder, :boolean, :default => true
    add_column :users, :layout_used, :string
  end

  def self.down
    remove_column :users, :referrer
    remove_column :users, :affiliate_id
    remove_column :users, :cancel_date
    remove_column :users, :cancel_reason
    remove_column :users, :send_weekly_reminder
    remove_column :users, :layout_used
  end
end
