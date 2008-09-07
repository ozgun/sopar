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
    @id = @article.id
    @article.destroy
    flash[:notice] = "Article deleted"
    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "#{e.exception}"
    respond_to do |format|
      format.html { redirect_to admin_articles_url }
      format.js
    end
  end


  #TODO: Do it with AJAX
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
  
  #TODO: Do it with AJAX
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

  #TODO: Do it with AJAX
  def close_comments
    @article = Article.find(params[:id])
    @article.change_comments_status(1)
    flash[:notice] = "Comments closed"
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.exception
    redirect_to :back
  end

  #TODO: Do it with AJAX
  def open_comments
    @article = Article.find(params[:id])
    @article.change_comments_status(0)
    flash[:notice] = "Comments allowed"
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.exception
    redirect_to :back
  end

end
