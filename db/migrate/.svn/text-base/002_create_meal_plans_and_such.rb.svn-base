class CreateMealPlansAndSuch < ActiveRecord::Migration
  def self.up
    create_table :meal_plans do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :weekly_meal_plan_id, :integer
    end
    
    create_table :meal_plan_recipes do |t|
      t.column :meal_plan_id, :integer
      t.column :recipe_id, :integer
      t.column :created_at, :datetime
    end
    
    create_table :recipes do |t|
      t.column :name, :string
      t.column :instructions, :string
      t.column :notes, :string
      t.column :servings, :integer
      t.column :created_at, :datetime
    end
    
    create_table :recipe_ingredients do |t|
      t.column :recipe_id, :integer
      t.column :ingredient_id, :integer
      t.column :quantity, :string
      t.column :measure, :string
      t.column :notes, :string
      t.column :alternate, :string
      t.column :created_at, :datetime
    end

    create_table :ingredients do |t|
      t.column :name, :string
      t.column :created_at, :datetime
      t.column :ingredient_category_id, :integer
    end

    create_table :ingredient_categories do |t|
      t.column :name, :string
    end
    ['Dairy/Refrigerator-Freezer Case', 'Produce', 'Meat/Poultry/Seafood', 'Bread/Grains/Pasta/Nuts/Seeds', 'Can/Bottle/Jar', 'Miscellaneous', 'Pantry'].each do |cat|
      IngredientCategory.create(:name => cat)
    end

    create_table :weekly_meal_plans do |t|
      t.column :week_number, :integer
      t.column :created_at, :datetime
    end

    (1..53).each do |week|
      mp = WeeklyMealPlan.create(:week_number => week)
      MealPlan.create(:name => 'meal1', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal2', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal3', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal4', :weekly_meal_plan_id => mp.id)
      MealPlan.create(:name => 'meal5', :weekly_meal_plan_id => mp.id)
    end
  end

  def self.down
    drop_table :meal_plans
    drop_table :meal_plan_recipes
    drop_table :recipes
    drop_table :recipe_ingredients
    drop_table :ingredients
    drop_table :ingredient_categories
    drop_table :weekly_meal_plans
  end
end
