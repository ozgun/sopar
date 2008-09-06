class Admin::StaticPagesController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @static_pages = StaticPage.paginate :per_page => 10, :page => params[:page], :order => "created_at DESC"
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
  end

  def new
    @static_page = StaticPage.new
  end

  def create
    @static_page = StaticPage.new(params[:static_page])
    @static_page.save!
    flash[:notice] = "Page created"
    redirect_to admin_static_page_url(@static_page)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :new, :id => @static_page
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
    redirect_to :action => :new
  end

  def show
    @static_page = StaticPage.find params[:id]
  end

  def edit
    @static_page = StaticPage.find params[:id]
  end

  def update
    @static_page = StaticPage.find params[:id]
    @static_page.update_attributes!(params[:static_page])
    flash[:notice] = "Page updated"
    redirect_to admin_static_page_url(@static_page)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :edit, :id => @static_page
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to admin_static_pages_url
  end

  def destroy
    @static_page = StaticPage.find params[:id]
    @id = @static_page.id
    @static_page.destroy
    flash[:notice] = "Page deleted"
    respond_to do |format|
      format.html { redirect_to admin_static_pages_url }
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "#{e.exception}"
    respond_to do |format|
      format.html { redirect_to admin_static_pages_url }
      format.js
    end
  end

  def publish
    @static_page = StaticPage.find(params[:id])
    @static_page.change_publish_status(1)
    flash[:notice] = "static_page status changed to published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to :back
  end
  
  def unpublish
    @static_page = StaticPage.find(params[:id])
    @static_page.change_publish_status(0)
    flash[:notice] = "static_page status changed to un-published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to :back
  end

end
