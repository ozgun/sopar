class TagsController < ApplicationController
  #TODO: index and show should implemented with only one method.

  def index
    @tag, @articles = search(params[:q])
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def show
    @tag, @articles = search(params[:id])
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end
  
  def tag
    @tag, @articles = search(params[:id])
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  protected

  def search(tag)
    articles = []
    if Tag.find(:first, :conditions => ["name=?", tag])
      articles = Article.find_tagged_with(tag).paginate :page => params[:page], :per_page => 10
    end
    return tag, articles
  #rescue Exception => e
    #log_exception(e)
    #return tag, articles
  end

end
