class CreateEmailStats < ActiveRecord::Migration
  def self.up
    create_table :member_email_stats do |t|
      t.column :user_id, :integer
      t.column :email_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
    create_table :newsletter_email_stats do |t|
      t.column :subscriber_id, :integer
      t.column :email_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :member_email_stats
    drop_table :newsletter_email_stats
  end
end
