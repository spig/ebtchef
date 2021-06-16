module PublicHelper
  def get_select_years
    today = Time.new;
    years = []
    (0..6).each do |yfn|
      years << today.years_since(yfn).year
    end
    years
  end

  def get_select_months
    [['01',1],['02',2],['03',3],['04',4],['05',5],['06',6],['07',7],['08',8],['09',9],['10',10],['11',11],['12',12]]
  end

  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      header_message = "Sorry, please correct these errors below to complete sign up"
      error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
      content_tag(:div,
        content_tag(:p, header_message) <<
        content_tag(:ul, error_messages), 
        :id => options[:id] || 'errorExplanation', :class => options[:class] || 'errorExplanation')
    else
      ''
    end
  end
  
  def get_dynamic_stylesheets stylesheets
    case stylesheets
    when Array
      stylesheets.collect do |stylesheet|
        stylesheet_link_tag *stylesheet
      end
    when String
      stylesheet_link_tag stylesheets
    else
      ''
    end
  end
	

end
