class Email < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.column :name, :string
      t.column :sent_at, :datetime
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :emails
  end
end
