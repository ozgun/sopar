class Admin::CommentsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments.sort_by_is_published.sort_by_date_desc.paginate :per_page => 10, :page => params[:page], :include => [:article]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def recent
    conditions = {}
    @comments = Comment.sort_by_is_published.sort_by_date_desc.paginate :per_page => 10, :page => params[:page], :include => [:article]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def new
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build
  end

  def create
    @comment = Comment.new(params[:comment])
    @article = Article.find(params[:article_id])
    @comment.article = @article
    @comment.save!
    flash[:notice] = "Comment added"
    redirect_to admin_article_comment_url(@article, @comment)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :new, :article_id => @article
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
    redirect_to :action => :new, :article_id => @article
  end

  def show
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
  end

  def edit
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def update
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.update_attributes!(params[:comment])
    flash[:notice] = "Article updated"
    redirect_to admin_article_comment_url(@article, @comment)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :edit, :article_id => @article, :id => @comment
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to recent_admin_comments_url
  end

  def destroy
    @comment = Comment.find params[:id]
    @id = @comment.id
    @comment.article.decrement!(:comments_published) if @comment.is_published == 1
    @comment.destroy
    flash[:notice] = "Comment deleted"
    respond_to do |format|
      format.html { redirect_to recent_admin_comments_url }
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    respond_to do |format|
      format.html { redirect_to recent_admin_comments_url }
      format.js
    end
  end

  def publish
    @comment = Comment.find params[:id]
    @comment.change_publish_status(1)
    flash[:notice] = "Comment status changed to published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :back
  end
  
  def unpublish
    @comment = Comment.find params[:id]
    @comment.change_publish_status(0)
    flash[:notice] = "Comment status changed to un-published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :back
  end

end
