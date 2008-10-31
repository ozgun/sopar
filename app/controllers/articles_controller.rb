class ArticlesController < ApplicationController

  def index
    if params[:category_id]
      @articles = Article.published.sort_by_date_desc.paginate :page => params[:page], :per_page => 1, 
        :conditions => ["category_id=?", params[:category_id].to_i]
    else
      @articles = Article.published.sort_by_date_desc.paginate :page => params[:page], :per_page => 1
    end
    @article = @articles[0]
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def show
    @article = Article.published.find(params[:id].to_i)
    @comments = @article.comments.published
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def rss
    @articles = Article.published.sort_by_date_desc.paginate :page => params[:page], :per_page => 10
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

  def archive
    @articles = Article.published.sort_by_date_desc.paginate :page => params[:page], :per_page => 20, 
      :include => [:category]
  end

end
