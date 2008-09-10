class Admin::ScreenshotsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def destroy
    @screenshot = Screenshot.find params[:id]
    @id = @screenshot.id
    @screenshot.destroy
    flash[:notice] = "Screenshot deleted"
    respond_to do |format|
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    respond_to do |format|
      format.js
    end
  end
end
