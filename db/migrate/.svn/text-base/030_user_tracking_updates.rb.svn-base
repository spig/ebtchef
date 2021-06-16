class UserTrackingUpdates < ActiveRecord::Migration
  def self.up
    add_column :users, :last_billed_on, :date, :default => nil
    rename_column :users, :billing_date, :next_billing_on
    rename_column :users, :cancel_date, :cancelled_on
  end

  def self.down
    remove_column :users, :last_billed_on
    rename_column :users, :next_billing_on, :billing_date
    rename_column :users, :cancelled_on, :cancel_date
  end
end
