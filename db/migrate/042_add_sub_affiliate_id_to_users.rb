class AddSubAffiliateIdToUsers < ActiveRecord::Migration
  def self.up
    #remove_column :users, :sub_affiliate_id
    add_column :users, :sub_affiliate_id, :string
  end

  def self.down
    remove_column :users, :sub_affiliate_id
  end
end
