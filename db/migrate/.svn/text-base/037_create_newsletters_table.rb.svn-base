class CreateNewslettersTable < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.column :created_on, :date
      t.column :availble_on, :date
      t.column :content, :text
      t.column :sent, :boolean
    end
  end

  def self.down
  end
end
