class CreateReferrals < ActiveRecord::Migration
  def self.up
    create_table :referrals do |t|
      t.column :referrer_id, :integer
      t.column :referred_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :referrals
  end
end
