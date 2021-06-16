class EmailClickthroughStats < ActiveRecord::Migration
  def self.up
    create_table :email_clickthrough_stats do |t|
      t.column :sent_to_id, :integer
      t.column :email_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :email_clickthrough_stats
  end
end
