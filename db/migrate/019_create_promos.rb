class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.column :name, :string
      t.column :price, :integer
      t.column :days_to_first_billing, :integer
    end

    Promo.create(:name => 'survey', :price => 395, :days_to_first_billing => 30)
    Promo.create(:name => 'newsletter', :price => 495, :days_to_first_billing => 30)

    add_column :users, :price, :integer
    add_column :users, :billing_date, :date
  end

  def self.down
    drop_table :promos

    remove_column :users, :price
    remove_column :users, :billing_date
  end
end
