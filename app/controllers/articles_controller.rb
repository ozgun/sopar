class ArticlesController < ApplicationController

  def index
    if params[:category_id]
      @articles = Article.paginate :page => params[:page], :per_page => 1, 
        :conditions => ["is_published=1 AND category_id=?", params[:category_id].to_i],
        :order => "created_at DESC"
    else
      @articles = Article.paginate :page => params[:page], :per_page => 1, 
        :conditions => ["is_published=1"],
        :order => "created_at DESC" 
    end
    @article = @articles[0]
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def show
    @article = Article.find :first, :conditions => ["is_published=1 AND id=?", params[:id].to_i]
    @comments = @article.comments.published
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def rss
    @articles = Article.paginate :page => params[:page], :per_page => 10, 
      :conditions => ["is_published=1"],
      :order => "created_at DESC" 
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

  def archive
    @articles = Article.paginate :page => params[:page], :per_page => 20, 
      :conditions => ["is_published=1"], :include => [:category],
      :order => "created_at DESC" 
  end

end
