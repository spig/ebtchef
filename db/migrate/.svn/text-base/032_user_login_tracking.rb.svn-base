class UserLoginTracking < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login_at, :datetime
    create_table :user_logs do |t|
      t.column :user_id, :integer
      t.column :ip_addr, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    remove_column :users, :last_login_at
    drop_table :user_logs
  end
end
