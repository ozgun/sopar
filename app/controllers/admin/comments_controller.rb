class Admin::CommentsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @article = Article.find(params[:article_id])
    @comments = @article.comments.paginate :per_page => 10, :page => params[:page],
      :include => [:article], :order => "is_published ASC, created_at DESC"
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
  end

  def recent
    conditions = {}
    @comments = Comment.paginate :per_page => 10, :page => params[:page],
      :conditions => conditions, :include => [:article], :order => "is_published ASC, created_at DESC"
  rescue Exception => e
    flash[:warning] = "Error!"
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
    flash[:warning] = "Error!"
    log_exception(e)
    redirect_to :action => :new, :article_id => @article
  end

  def show
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
  rescue Exception => e
    flash[:warning] = e.exception
    log_exception(e)
  end

  def edit
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
  rescue Exception => e
    flash[:warning] = e.exception
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
    flash[:warning] = "Error!"
    redirect_to recent_admin_comments_url
  end

  def destroy
    @comment = Comment.find params[:id]
    @id = @comment.id
    @comment.article.decrement!(:comments_published)
    @comment.destroy
    flash[:notice] = "Comment deleted"
    respond_to do |format|
      format.html { redirect_to recent_admin_comments_url }
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "#{e.exception}"
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
    flash[:warning] = e.exception
    redirect_to :back
  end
  
  def unpublish
    @comment = Comment.find params[:id]
    @comment.change_publish_status(0)
    flash[:notice] = "Comment status changed to un-published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.exception
    redirect_to :back
  end

end