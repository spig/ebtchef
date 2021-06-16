class ReferralPaidOn < ActiveRecord::Migration
  def self.up
    add_column :referrals, :paid_on, :date, :default => nil
  end

  def self.down
    remove_column :referrals, :paid_on
  end
end
