class CreateFavoriteRecipes < ActiveRecord::Migration
  def self.up
    create_table :favorite_recipes do |t|
      t.column :user_id, :integer
      t.column :recipe_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :favorite_recipes
  end
end
