class StaticPagesController < ApplicationController
  def show
    @static_page = StaticPage.published.find(params[:id].to_i)
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end
end
