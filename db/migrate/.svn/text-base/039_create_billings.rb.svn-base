class CreateBillings < ActiveRecord::Migration
  def self.up
    create_table :billings do |t|
      t.column :user_id, :integer
      t.column :billed_on, :date
      t.column :amount_billed, :integer
      t.column :status, :boolean
      t.column :response, :text
      t.column :error_msg, :string
    end
  end

  def self.down
    drop_table :billings
  end
end
