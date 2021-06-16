module Admin::NewslettersHelper

  def rc field
    RedCloth.new(@newsletter[field]).to_html
  end

  def items field
    RedCloth.new(@newsletter[field].gsub(/\r\n|\r|\n/, "<br />\r\n")).to_html
  end

end
