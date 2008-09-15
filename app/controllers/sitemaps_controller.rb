class SitemapsController < ApplicationController
  skip_before_filter :login_from_cookie
  layout nil
  
  def index
    @articles = Article.find :all, :conditions => ["is_published=1"], :order => "created_at DESC"
    @static_pages = StaticPage.find :all, :conditions => ["is_published=1"], :order => "created_at DESC"
    @site_domain = (request.env['HTTP_X_FORWARDED_SERVER']) ? request.env['HTTP_X_FORWARDED_SERVER'] : "localhost:3000"
    respond_to do |format|
      format.xml
    end
  end
end
