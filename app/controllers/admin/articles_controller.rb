class Admin::ArticlesController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    conditions = {}
    conditions[:category_id] = params[:category_id] if params[:category_id]
    @articles = Article.paginate :per_page => 10, :page => params[:page],
      :conditions => conditions, :include => [:category], :order => "created_at DESC"
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    @article.user = @current_user
    @article.save!
    flash[:notice] = "Article created"
    redirect_to admin_article_url(@article)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :new, :id => @article
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
    redirect_to :action => :new
  end

  def show
    @article = Article.find params[:id]
  end

  def edit
    @article = Article.find params[:id]
  end

  def update
    @article = Article.find params[:id]
    @article.update_attributes!(params[:article])
    flash[:notice] = "Article updated"
    redirect_to admin_article_url(@article)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :edit, :id => @article
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to admin_articles_url
  end

  def destroy
    @article = Article.find params[:id]
    @article.destroy
    flash[:notice] = "Article deleted"
    redirect_to admin_articles_url
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error! Couldn't delete article!"
    redirect_to admin_articles_url
  end


  def publish
    @article = Article.find(params[:id])
    @article.change_publish_status(1)
    flash[:notice] = "Article status changed to published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to :back
  end
  
  def unpublish
    @article = Article.find(params[:id])
    @article.change_publish_status(0)
    flash[:notice] = "Article status changed to un-published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "Error!"
    redirect_to :back
  end

end
