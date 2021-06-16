class Admin::ToolsController < Admin::ApplicationController
  
  layout 'admin'
  before_filter :authorize_admin
  
    def index
      @affiliates = Affiliate.find(:all)
    end
    
    def clear_sessions
      # raise params.inspect
      interval = params[:interval] ? params[:interval].to_i : 30
      CGI::Session::ActiveRecordStore::Session.destroy_all( ['updated_at <?', interval.minutes.ago] )
      flash[:notice] = "Stale Sessions Cleared"
      redirect_to :action => 'index'
    end
    ########################################################################
    # get_mp and get_sl
    # are simple tools to get meal plans and shopping lists from a list of weeks
    #
    ########################################################################
    def get_mp
      @page_css = "mealplan"
      @week_list = 42..52
      @mplans = Hash.new
      @rec = Hash.new
      @week_list.each do |wk|
        if wk
          @mplans[wk] = CustomWeekMealPlan.new wk
          @rec[wk] = Recipe.find(@mplans[wk].recipes, :include => [ 'ingredients', 'recipe_ingredients' ])
        end
      end
    end

    def get_sl
      @page_css = 'shopping_list'
      @week_list = 42..52
      @mplans = Hash.new
      uniq_recipe_ids = Hash.new
      @canned_jar_ingredients = Hash.new
      @dairy_frozen_ingredients = Hash.new
      @grains_nuts_seeds_ingredients = Hash.new
      @meat_seafood_ingredients = Hash.new
      @miscellaneous_ingredients = Hash.new
      @produce_ingredients = Hash.new
      @pantry_ingredients = Hash.new
      @ingredients = Hash.new
      @week_list.each do |wk|
        if wk
          @mplans[wk] = CustomWeekMealPlan.new wk
        end    
      # end
      # @week_list.each do |wk|
      # if wk
        uniq_recipe_ids[wk] = @mplans[wk].recipes.uniq
      # end  



      @ingredients[wk] = RecipeIngredient.find(:all,
        :conditions => ['recipe_id in (?)', @mplans[wk].recipes],
        :include => ['ingredient', 'recipe'],
        :order => 'ingredients.ingredient_category_id,ingredients.name')
      uniq_recipe_ids[wk].each do |ur|
        same_recipe_count = @mplans[wk].recipes.select { |i| i==ur }.size
        if same_recipe_count > 1
          recipe_ingredients_to_add = @ingredients[wk].select { |ri| ri.recipe.id == ur }
          (2..same_recipe_count).each do
            recipe_ingredients_to_add.each do |ri2add|
              @ingredients[wk] << ri2add
            end
          end
        end
      end
      @ingredients[wk].flatten!
    end
      @ingredient_categories = IngredientCategory.find(:all).inject({}) do |cats,ic|
        cats[ic.id] = ic.name
        cats
      end

      @week_list.each do |wk|
        @canned_jar_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::CANNED_JAR_CATEGORY)
        @dairy_frozen_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::DAIRY_FROZEN_CATEGORY)
        @grains_nuts_seeds_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::GRAINS_NUTS_SEEDS_CATEGORY)
        @meat_seafood_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::MEAT_SEAFOOD_CATEGORY)
        @miscellaneous_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::MISCELLANEOUS_CATEGORY)
        @produce_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::PRODUCE_CATEGORY)

        @pantry_ingredients[wk] = IngredientCategory.filter(@ingredients[wk], IngredientCategory::PANTRY_CATEGORY).collect do |ing|
          ing[1][:name]
        end.uniq.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }
      end

    end

    #############################################################
    #
    # END TOOLS
    #
    #############################################################
    
end
