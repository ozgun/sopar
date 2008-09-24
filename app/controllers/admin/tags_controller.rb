class Admin::TagsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @tags = Tag.paginate :per_page => 10, :page => params[:page], :order => "name DESC"
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def show
    @tag = Tag.find(params[:id])
    @articles = Article.find_tagged_with(@tag)
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :action => "index"
  end
  
  def search
    @tags = Tag.find(:all, :conditions => ["name LIKE ?", "{params[:q]}%"])
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :action => "index"
  end
  
  def update
    @tag = Tag.find(params[:id])
    @tag.update_attributes(params[:tag])
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @id = @tag.id
    @tag.destroy
    respond_to do |format|
      format.js
    end
  end

end
