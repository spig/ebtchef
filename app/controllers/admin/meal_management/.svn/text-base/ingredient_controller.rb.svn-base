class Admin::MealManagement::IngredientController < Admin::MealManagement::ApplicationController
  layout 'admin'

  def auto_complete_for_ingredient_category_name
    @categories = IngredientCategory.find(:all,
      :conditions => [ 'LOWER(name) LIKE ?', '%' + params[:ingredient_category][:name] + '%' ] )
    render :inline => "<%= auto_complete_result(@categories, 'name') %>"
  end
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @ingredients = Ingredient.find(:all, :order => 'name')
    @ingredient_categories = IngredientCategory.find(:all).inject({}) do |cats,ic|
      cats[ic.id] = ic.name
      cats
    end
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    Ingredient.create params[:ingredient]
  end

  def edit
    @ingredient = Ingredient.find(params[:id], :include => 'ingredient_category')
    @ingredient_category = @ingredient.ingredient_category
  end

  def update
    ingredient_category = IngredientCategory.find_by_name(params[:ingredient_category][:name])
    ingredient = Ingredient.find(params[:id])

    ingredient.attributes = params[:ingredient]
    ingredient.ingredient_category_id = ingredient_category.id

    ingredient.save!

    redirect_to :action => 'list'
  end
end
