module Member::MainHelper
  
  def meal_plan_week today = Time.now
    starting_wednesday = (today - Ebtchef::DateCalculation.days_to_most_recent_wednesday(today).days).midnight
    ending_tuesday = (starting_wednesday + 6.days).midnight
    "#{starting_wednesday.strftime("%b %d")} - #{ending_tuesday.strftime("%b %d")}"
  end
  
  def ingredient_details ing
    if block_given?
      yield ing
    else
      #ing = ing[1]
      details = ing[:name]
      details += (ing[:quantity] and ing[:quantity] != 0.0) ? " (#{float_to_fraction(ing[:quantity])}" : ''
      details += (details.size > 0 and ing[:measure] and ing[:measure].size > 0) ? " #{ing[:measure]}" : ''
      details += (details.size > 0 and ing[:shopping_notes] and ing[:shopping_notes].size > 0) ? ", #{ing[:shopping_notes]}" : ''
      details += ')' if details.match(/\(/)
      details += "<br />"
    end
  end
  
  def show_category name, ingredients, &details
    if ingredients.size > 0
       %Q|<div class="shopping_list_category">#{name}</div>| +
      '<p>' +
      if details
        ingredients.collect do |ing|
          ingredient_details(ing, &details)
        end
      else
        ingredients.sort do |a,b|
          a[1][:name].to_s.downcase <=> b[1][:name].to_s.downcase
        end.collect do |n|
          ing = ingredients[n[0]]
          ingredient_details(ing)
        end
      end.join('') +
      '</p>'
    else
      ''
    end
  end
  
  def add_favorite_link recipe
    if @favorites.to_a.include?(recipe)
      render :partial => 'favorite_added', :locals => { :recipe_id => recipe.id }
    else
      link_to_remote( image_tag('member/add_to_favorites', :alt => 'add to favorites', :style => "border: 0px;"), {:url => { :action => 'add_favorite', :id => recipe.id }}, :id => "add-favorite-#{recipe.id}")
    end
  end
  
  private
  
  def float_to_fraction num
    whole = num.to_i
    rem = num - whole
    fraction = case
               when rem <= 0.0
                 ''
               when rem <= 0.25
                 '1/4'
               when rem <= 0.334
                 '1/3'
               when rem <= 0.5
                 '1/2'
               when rem <= 0.667
                 '2/3'
               when rem <= 0.75
                 '3/4'
               when rem <= 1.0
                 whole += 1
                 ''
               else
                 ''
               end
                   
    if whole == 0
      fraction unless fraction.empty?
    else
      if fraction.empty?
        whole.to_s
      else
        "#{whole.to_s} #{fraction}"
      end
    end
  end
  
end
