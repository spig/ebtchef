class Admin::NewslettersController < Admin::ApplicationController

  layout 'admin', :except=>:show
#  layout 'newsletter', :only=>:show

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @newsletter_pages, @newsletters = paginate :newsletters, :order=>'available_on desc', :per_page=>10
  end

  def show
    @nonsub = params[:nonsub]
    @newsletter = Newsletter.find(params[:id])
  end

  def test
    show
    test_email = Email.new(:name => "Test Weekly Email for #{@newsletter.available_on.strftime("%Y-%m-%d")}",
                 :recipient_count => 1,
                 :sent_at => Time.now,
                 :email_list => 'member')
    begin
      if @nonsub
        Notifications.deliver_weekly_nonsub(@newsletter, @user, test_email, true)
      else
        Notifications.deliver_weekly(@newsletter, @user, test_email, true)
      end
      flash[:notice] = "#{@nonsub ? 'Non-subscriber' : 'Subscriber'} newsletter test was sent to #{@user.email}."
    rescue
      flash[:notice] = "Test failed: #{$!}"
    end
    redirect_to :action => 'show', :id => @newsletter, :nonsub=>@nonsub
  end

  def new
    @newsletter = Newsletter.new
    last = Newsletter.find :first, :order=>'available_on desc'
    @newsletter.available_on = last.available_on + 7 if last
  end

  def create
    @newsletter = Newsletter.new(params[:newsletter])
    # redcloth
    # @redclothed = RedCloth.new(@content).to_html
    if @newsletter.save
      flash[:notice] = 'Newsletter was successfully created.'
      redirect_to :action => 'show', :id => @newsletter
    else
      render :action => 'new'
    end
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(params[:newsletter])
      flash[:notice] = 'Newsletter was successfully updated.'
      redirect_to :action => 'show', :id => @newsletter
    else
      render :action => 'edit'
    end
  end

  def destroy
    Newsletter.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
