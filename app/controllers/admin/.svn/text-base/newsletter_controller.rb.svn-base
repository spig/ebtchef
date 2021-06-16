class Admin::NewsletterController < Admin::ApplicationController
  layout 'admin'
  # PRUNE
  def index
    # @content = italicize_chefs(params[:content].to_s)
    # @redclothed = RedCloth.new(@content).to_html
  end
  
  def add
    @newsletter = Newsletter.new()
    @newsletter.content = params['newsletter']['content']
    available = Date.civil(params['newsletter']['available_on(1i)'].to_i,params['newsletter']['available_on(2i)'].to_i,params['newsletter']['available_on(3i)'].to_i)
    @newsletter.created_on = Date::today
    @newsletter.available_on = available
    # raise @newsletter.inspect
    @newsletter.save
    render :text => @newsletter.content.to_s
  end
  private
  
  def italicize_chefs content
    content.gsub!(/\bEverything but the Chef\b/i, "_Everything but the Chef_")
    content.gsub!(/\bchef\b/i, "_Chef_")
    content
  end
  
end
class Content
  
end