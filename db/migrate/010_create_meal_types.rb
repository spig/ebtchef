class CreateMealTypes < ActiveRecord::Migration
  def self.up
    create_table :meal_plan_types do |t|
      t.column :name, :string
    end
    
    %w(quick crockpot make-ahead).each do |mpt|
      MealPlanType.create(:name => mpt)
    end
  end

  def self.down
    drop_table :meal_plan_types
  end
end
