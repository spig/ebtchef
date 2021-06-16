class CreateSiteConfigurations < ActiveRecord::Migration
  def self.up
    create_table :site_configurations do |t|
      t.column :name, :string
      t.column :value, :text
    end
  end

  def self.down
    drop_table :site_configurations
  end
end
