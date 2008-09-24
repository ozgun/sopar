class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.find :first, :conditions => ["is_published=1 AND id=?", params[:id].to_i]
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end
end
