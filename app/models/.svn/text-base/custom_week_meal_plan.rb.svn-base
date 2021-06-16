class CustomWeekMealPlan

  class CustomMealPlan
    attr_accessor :meal_plan_type, :note_tip, :id
    
    def initialize
      @recipes = Array.new
      @meal_plan_type = ''
      @note_tip = ''
    end

    def add_recipe *recipes
      @recipes << recipes
      @recipes.flatten!
    end

    def delete_recipe *recipes
      recipes.each do |recipe|
        rejected = false
        @recipes.reject! do |n|
          if rejected
            false
          else
            rejected = (n == recipe.to_i)
          end
        end
      end
    end
    
    def has_recipe? recipe_id
      @recipes.select { |r| r = recipe_id }
    end
    
    def recipes
      @recipes
    end
    
  end
  
#  attr_accessor :custom_meal_plans

  #def initialize week=Date.new(2.days.ago.year, 2.days.ago.month, 2.days.ago.day).cweek#week=(Time.now-2.day).to_date.cweek
  def initialize week=WeeklyMealPlan.week
    # set the week of the year for determining which meal plan to use by default
    @week_number = week
    @custom_meal_plans = Array.new
    
    # get meal_plans for the week
    wmp = WeeklyMealPlan.find_by_week_number(@week_number, :include => 'meal_plans')
    
    # assign recipes to @custom_meal_plans
    wmp.meal_plans.collect do |meal_plan|
      cmp = CustomMealPlan.new
      cmp.id = meal_plan.id
      @custom_meal_plans << cmp
      if meal_plan.note_tip
        cmp.note_tip = meal_plan.note_tip
      end
      if meal_plan.meal_plan_type
        cmp.meal_plan_type = meal_plan.meal_plan_type.name
      end
      meal_plan.meal_plan_recipes.sort{|a,b| a.position <=> b.position}.each do |mpr|
        cmp.add_recipe mpr.recipe_id
      end
    end
  end
  
  def delete_recipe recipe_id
    @custom_meal_plans.each do |cmp|
      cmp.delete_recipe( recipe_id ) if cmp.has_recipe?( recipe_id.to_i )
    end
    CGI::escape(Marshal.dump(self))
  end
  
  def add_recipe( meal_plan_id, recipe_id )
    cmp = @custom_meal_plans.select {|cmp| cmp.id == meal_plan_id}[0]
    if cmp
      cmp.add_recipe(recipe_id)
      cmp.meal_plan_type = ''
      #cmp.note_tip = '* Custom meal plan *'
      CGI::escape(Marshal.dump(self))
    end
  end
  
  def meal_plans
    @custom_meal_plans
  end
  
  def recipes meal_number=nil
    if (meal_number)
      @custom_meal_plans[meal_number]
    else
      @custom_meal_plans.inject([]) do |recipes, meal_plan|
        recipes += meal_plan.recipes
        recipes.flatten
      end
    end
  end
  
  def self.gen_cookie
    cwmp = CustomWeekMealPlan.new
    CGI::escape(Marshal.dump(cwmp))
  end
  
  def self.from_escaped_marshaled data
    Marshal.load(CGI::unescape(data))
  end
  
end