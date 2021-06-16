class AddRoutingNumber < ActiveRecord::Migration
  def self.up
    add_column :users, :routing_number, :string
  end

  def self.down
    remove_column :users, :routing_number
  end
end
