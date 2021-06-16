class AddAffiliateBitToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_affiliate, :boolean
    User.reset_column_information
    User.find(:all).each do |u|
      u.update_attribute :is_affiliate, false
    end
  end

  def self.down
    remove_column :users, :is_affiliate
  end
end
