class CreateTrackingLogs < ActiveRecord::Migration
  def self.up
    create_table :affiliates do |t|
      t.column :name, :string
      t.column :created_on, :date
    end
    create_table :affiliate_logs do |t|
      t.column :affiliate_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
    create_table :referral_logs do |t|
      t.column :user_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end    
    create_table :referrer_logs do |t|
      t.column :referrer_id, :integer
      t.column :ip_addr, :string
      t.column :uri, :string
      t.column :created_at, :datetime
    end
    create_table :referrers do |t|
      t.column :host, :string
      t.column :created_on, :date
    end    
  end

  def self.down
    drop_table :affiliates
    drop_table :affiliate_logs
    drop_table :referral_logs
    drop_table :referrer_logs
    drop_table :referrers
  end
end
