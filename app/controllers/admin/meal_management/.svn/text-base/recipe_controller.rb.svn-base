class Admin::MealManagement::RecipeController < Admin::MealManagement::ApplicationController
  layout 'admin'

  auto_complete_for :ingredient, :name
  auto_complete_for :ingredient_category, :name

  verify :method => :post, :only => :remove_ingredient_from_recipe
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @recipes = Recipe.find(:all, :order => 'name')
  end
  
  def new
    @meal_plan_id = params[:meal_plan_id]
    @recipe = Recipe.new
  end
  
  def create
    recipe = Recipe.find_or_create_by_name(params[:recipe][:name])
    MealPlanRecipe.create(:meal_plan_id => params[:meal_plan_id].to_i, :recipe_id => recipe.id)
    
    redirect_to( :controller => 'recipe', :action => 'edit', :id => recipe.id, :week => params[:week].to_i ) and return unless recipe.notes || recipe.instructions || recipe.servings
    redirect_to :controller => 'weekly_meal_plan', :week => params[:week].to_i
  end
  
  def edit
    @recipe = Recipe.find(params[:id], :include => ['ingredients','recipe_ingredients'])
    @week = params[:week]
  end
  
  def update
    recipe = Recipe.find_by_name(params[:recipe][:name]) || Recipe.find(params[:id])
    recipe.update_attributes(params[:recipe])
    redirect_to :controller => 'weekly_meal_plan', :week => params[:week].to_i
  end
  
  def add_ingredient_to_recipe
    params[:ingredient].each_pair { |k,v| params[:ingredient][k] = v.strip }
    ingredient = Ingredient.find_or_create_by_name(params[:ingredient][:name])
    if params[:ingredient_category][:name].strip.size > 0
      ingredient_category = IngredientCategory.find_by_name(params[:ingredient_category][:name].strip)
      ingredient.ingredient_category_id = (ingredient_category and ingredient_category.id) ? ingredient_category.id : nil
      ingredient.save
    end
    recipe = Recipe.find(params[:id])
    params[:recipe_ingredient].delete(:measure) if params[:recipe_ingredient][:measure].to_s.empty?
    params[:recipe_ingredient][:measure].to_s.downcase! if params[:recipe_ingredient].has_key? :measure
    @recipe_ingredient = RecipeIngredient.create(params[:recipe_ingredient].merge({:ingredient_id => ingredient.id, :recipe_id => recipe.id}))
    if ! @recipe_ingredient.new_record?
      render :update do |page|
        page['ingredient_form'].reset
        page.insert_html :bottom, 'ingredient_list', :partial => 'recipe_ingredient', :object => @recipe_ingredient
        page.visual_effect :highlight, "ingredient_#{@recipe_ingredient.id}", :duration => 2
        page['recipe_ingredient_quantity'].focus
      end
    else
      render :update do |page|
        if @recipe_ingredient.errors.size > 0
          page.alert "There were errors when adding this ingredient:\n\n" + @recipe_ingredient.errors.full_messages.join("\n")
        else
          page.alert "An Unknown error has occurred.  It wasn't your fault and can probably be fixed :)"
        end
      end
    end
  rescue => e
    render :update do |page|
      page.alert "#{e.message}\n#{e.backtrace.join('\n')}"
    end
  end
  
  def edit_recipe_ingredient
    @ri = RecipeIngredient.find(params[:id])
    @ingredient = @ri.ingredient_id.nil? ? nil : Ingredient.find(@ri.ingredient_id)
    @ingredient_category = @ingredient.nil? ? nil : IngredientCategory.find(@ingredient.ingredient_category_id)
  end
  
  def update_recipe_ingredient
    # update recipe_ingredient
    ri = RecipeIngredient.find(params[:id])
    ri.update_attributes(params[:recipe_ingredient])
    i = Ingredient.find(ri.ingredient_id)
    i.name = params[:ingredient][:name]
    ic = IngredientCategory.find_by_name(params[:ingredient_category][:name])
    i.ingredient_category_id = ic.id unless ic.id == i.ingredient_category_id or ic.nil?
    i.save
    redirect_to :action => :edit, :id => ri.recipe_id
  end
  
  def remove_ingredient_from_recipe
    Recipe.find(params[:recipe_id].to_i).recipe_ingredients.find(params[:recipe_ingredient_id].to_i).destroy
    @ri_id = params[:recipe_ingredient_id]
  end
  
  def move_ingredient_higher
    move_ingredient_position(params[:id], :higher)
  end
  
  def move_ingredient_lower
    move_ingredient_position(params[:id], :lower)
  end
  
  def move_ingredient_position recipe_ingredient_id, direction
    raise "Recipe Ingredient ID was not specified in file #{__FILE__}, line # #{__LINE__}" if recipe_ingredient_id.nil?
    ri = RecipeIngredient.find(recipe_ingredient_id)
    case direction
      when :higher
        ri.move_higher
      when :lower
        ri.move_lower
      else
        raise "Direction to move ingredient was not specified (file #{__FILE__}, line # #{__LINE__})"
    end
    render :update do |page|
      @recipe = Recipe.find(ri.recipe_id, :include => ['ingredients','recipe_ingredients'])
      page.replace 'ingredient_list', :partial => 'recipe_ingredient_list'
      page.visual_effect :highlight, 'ingredient_list'
    end
    #redirect_to :action => :edit, :id => ri.recipe_id
  end
  
end
