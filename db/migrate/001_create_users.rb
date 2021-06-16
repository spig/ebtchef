class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :address, :string
      t.column :city, :string
      t.column :state, :string
      t.column :phone, :string
      t.column :zip, :string
      t.column :hash_password, :string
      t.column :cc_exp, :date
      t.column :ccnum, :string
      t.column :checkacct, :string
      t.column :last_billing_response, :text
      t.column :billing_info, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
