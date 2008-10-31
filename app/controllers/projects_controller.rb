class ProjectsController < ApplicationController

  def index
    @projects = Project.published.sort_by_position.paginate :page => params[:page], :per_page => 10
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def show
    @project = Project.published.find(params[:id].to_i)
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def toggle_show
    session[:hide_projects] = nil
    respond_to do |format|
      format.js {render :layout => false }
    end
  end

  def toggle_hide
    session[:hide_projects] = true
    respond_to do |format|
      format.js {render :layout => false }
    end
  end

end
