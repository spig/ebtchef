class Member::MainController < Member::ApplicationController
  layout 'member'
  # caches_page :how_it_works, :faq, :about, :getting_most, :how_chef_works
  include ExceptionNotifiable
  
  def index
    @user = User.find_by_id(session[:user_id])
    weekly_meal_plans
    render :action => 'weekly_meal_plans'
  end
  
  def reset
    reset_meal_plans
  end
  
  def reset_meal_plans
    cookies['weekly_meal_plan'] = nil
    redirect_to :action => 'index'
  end
    
  def previous
    if session[:wks_ago]
     session[:wks_ago] +=1
    else
     session[:wks_ago] = 1
    end
    weekly_meal_plans
    render :action => 'weekly_meal_plans'
  end
  
  def next
    if session[:wks_ago]
      if session[:wks_ago] > 1 || User.find(session[:user_id]).admin?
       session[:wks_ago] -= 1
      else
       session[:wks_ago] = nil
      end
    end
    weekly_meal_plans
    render :action => 'weekly_meal_plans'  
  end
  
  def cweek
    session[:wks_ago] = nil
    weekly_meal_plans
    render :action => 'weekly_meal_plans'
  end
  
  def weekly_meal_plans
    @cwmp = nil
    #@cweek = Date.new(2.days.ago.year, 2.days.ago.month, 2.days.ago.day).cweek
    @cweek = WeeklyMealPlan.week
    if session[:wks_ago]
      # raise session[:wks_ago].to_s
      #@week_number = ((session[:wks_ago].weeks.ago.to_date) - 2).cweek.to_s
      @week_number = WeeklyMealPlan.week(-session[:wks_ago]).to_s
      # raise @week_number.to_s
    else
      @week_number = @cweek
    end
    # find when the user joined and give them a extra week to see meal plans
    @joined_on = (User.find_by_id(session[:user_id]).created_at - 1.week).to_date
    @limit = @joined_on >= session[:wks_ago].weeks.ago.to_date ? true : false if session[:wks_ago]
    @page_css = "mealplan"
    # @week = Date.new(2.days.ago.year, 2.days.ago.month, 2.days.ago.day).cweek
    # if cookies['weekly_meal_plan']
      # cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
    # else
    if session[:wks_ago] and session[:wks_ago] > 0
      #cwmp = CustomWeekMealPlan.new(((session[:wks_ago].weeks.ago.to_date) - 2.day).cweek)
      cwmp = CustomWeekMealPlan.new(WeeklyMealPlan.week(-session[:wks_ago]))
    else
      # this should be the current week
      if cookies['weekly_meal_plan']
        cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
      else 
        cwmp = CustomWeekMealPlan.new @cweek  
      end
    end
    
    if params[:week]
      @week = params[:week]
      @week = '1' if @week.to_i > 106
      cwmp = CustomWeekMealPlan.new @week
    end
    
    @recipes = Recipe.find(cwmp.recipes, :include => [ 'ingredients', 'recipe_ingredients' ])
    @cwmp = cwmp
    # include favorites for displaying added to favorites ...
    @favorites = User.find(session[:user_id], :include => 'recipes').recipes
  end

  def shopping_list
    @page_css = 'shopping_list'
    @cwmp = nil
    #@cweek = Date.new(2.days.ago.year, 2.days.ago.month, 2.days.ago.day).cweek
    @cweek = WeeklyMealPlan.week
    if session[:wks_ago] and session[:wks_ago] > 0
      #cwmp = CustomWeekMealPlan.new(((session[:wks_ago].weeks.ago.to_date) - 2.day).cweek)
      cwmp = CustomWeekMealPlan.new(WeeklyMealPlan.week(-session[:wks_ago]))
    else
      # this should be the current week
      if cookies['weekly_meal_plan']
        cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
      else 
        cwmp = CustomWeekMealPlan.new @cweek  
      end
    end
    # old code
    # @week = Date.new(2.days.ago.year, 2.days.ago.month, 2.days.ago.day).cweek
    # if cookies['weekly_meal_plan']
    #   cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
    # else
    #   cwmp = CustomWeekMealPlan.new
    # end
    if params[:week]
      @week = params[:week]
      @week = '1' if @week.to_i > 106
      cwmp = CustomWeekMealPlan.new @week
    end
    uniq_recipe_ids = cwmp.recipes.uniq
    ingredients = RecipeIngredient.find(:all,
      :conditions => ['recipe_id in (?)', cwmp.recipes],
      :include => ['ingredient', 'recipe'],
      :order => 'ingredients.ingredient_category_id,ingredients.name')
    uniq_recipe_ids.each do |ur|
      same_recipe_count = cwmp.recipes.select { |i| i==ur }.size
      if same_recipe_count > 1
        recipe_ingredients_to_add = ingredients.select { |ri| ri.recipe.id == ur }
        (2..same_recipe_count).each do
          recipe_ingredients_to_add.each do |ri2add|
            ingredients << ri2add
          end
        end
      end
    end
    ingredients.flatten!
    
    @ingredient_categories = IngredientCategory.find(:all).inject({}) do |cats,ic|
      cats[ic.id] = ic.name
      cats
    end
    
    @canned_jar_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::CANNED_JAR_CATEGORY)
    @dairy_frozen_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::DAIRY_FROZEN_CATEGORY)
    @grains_nuts_seeds_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::GRAINS_NUTS_SEEDS_CATEGORY)
    @meat_seafood_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::MEAT_SEAFOOD_CATEGORY)
    @miscellaneous_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::MISCELLANEOUS_CATEGORY)
    @produce_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::PRODUCE_CATEGORY)
    
    @pantry_ingredients = IngredientCategory.filter(ingredients, IngredientCategory::PANTRY_CATEGORY).collect do |ing|
      ing[1][:name]
    end.uniq.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }
  end
  
  def favorites
    u = User.find(session[:user_id], :include => 'recipes')
    @favorites = u.recipes
    @page_css = 'favorites'
  end
  
  def delete_favorite
    if request.post?
      FavoriteRecipe.find_by_user_id_and_recipe_id(User.find(session[:user_id]).id, params[:id]).destroy
      render :update do |page|
        page.visual_effect :drop_out, "favorite_recipe_#{params[:id]}"
      end
    else
      render :nothing
    end
  rescue
    render :nothing
  end
  
  def delete_recipe
    if request.post?
      @current_cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
      cookies['weekly_meal_plan'] = @current_cwmp.delete_recipe(params[:id])
      @id = params[:id]
      render :update do |page|
        page.visual_effect :drop_out, "recipe-#{@id}"
      end
    else
      render nothing
    end
  end
  
  def add_favorite
    fr = FavoriteRecipe.new(:user_id => session[:user_id], :recipe_id => params[:id])
    if fr.save
      render :update do |page|
        page.replace "add-favorite-#{params[:id]}", :partial => 'favorite_added', :locals => { :recipe_id => params[:id] }
        page.visual_effect :highlight, "favorite-added-#{params[:id]}"
      end
    else
      render :nothing => true
    end
  end
  
  def how_chef_works
    @show_menu = true
    @page_css = 'how_chef_works'
    render :template => 'public/how_chef_works'
  end
  
  def contact
    @show_menu = true
    @page_css = 'contact'
    @user = User.find(session[:user_id])
    @topic = params[:topic] || 'general'
    @previous_controller = params[:controller]
    @previous_action = params[:action]
    render :template => 'public/contact'
  end
  
  def faq
    @show_menu = true
    render :template => 'public/faq'
  end
  
  def about
    @show_menu = true
    @show_signup = false
    @show_viral = true
    render :template => 'public/learn_more'
  end
  
  def askthechef
    @email = User.find(session[:user_id]).email
  end
  
  def getting_most
    @page_css = 'getting_most'
  end
  
  def submit
    @email = params[:email_address] || User.find(session[:user_id]).email
    @question = params[:question]
    if @question and @question.size > 0
      Notifications.deliver_askthechef_question @email, @question
      flash.now[:notice] = "Your question was submitted.  Thank you."
    else
      flash.now[:error] = "Please submit a question and your email address."
    end
    render :action => 'askthechef'
  end
  
  def viral
    @user = User.find(session[:user_id])
    @page_css = "viral"
  end
  
  def tell_a_friend
    @user=User.find(session[:user_id])
    @page_css = "viral"
    recipients = params[:emails].split /[,;\s]+/
    recipients.reject! { |r| ! r.match User::EMAIL_REGEX }
    recipients.each do |recipient|
      message = params[:message].dup
      Notifications.deliver_tellafriend(recipient, params[:subject], message, @user)
    end
    # update the number of viral sent for this member
    if (recipients.to_a.size > 0)
      @user.viral_sent_count = @user.viral_sent_count.to_i + recipients.to_a.size
      @user.save
    end
    success_message = "Congratulations! Your message has been sent and you are on your way to free Chef service. Please tell more friends now."
    if request.xhr?
      render :update do |page|
        page.hide 'sending_message'
        page.replace_html 'message_sent', success_message
        page.show 'message_sent'
        page.visual_effect :highlight, 'message_sent'
        page.assign 'document.viral_form.emails.value', ''
        page.show 'submit_viral'
      end
    else
      flash.now[:notice] = success_message
      render :action => 'viral'
    end
  end
  
  def add_to_meal_plan
    redirect_to member_url and return unless @meal_plan_id = params[:id].to_i
    u = User.find(session[:user_id], :include => 'recipes')
    if params[:favorite]
      favorite = params[:favorite].to_i
      if u.recipes.collect{|r|r.id}.include?(favorite)
        cwmp = CustomWeekMealPlan.from_escaped_marshaled(cookies['weekly_meal_plan'])
        cookies['weekly_meal_plan'] = cwmp.add_recipe(@meal_plan_id, favorite)
        flash[:notice] = "Favorite has been added"
      end
      redirect_to member_url
    else
      @favorites = u.recipes
      @add_to_meal_plan = true
      @page_css = 'favorites'
      render :action => 'favorites'
    end
  end  
end  

