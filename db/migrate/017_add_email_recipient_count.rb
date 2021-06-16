class AddEmailRecipientCount < ActiveRecord::Migration
  def self.up
    add_column :emails, :recipient_count, :integer
  end

  def self.down
    remove_column :emails, :recipient_count
  end
end
