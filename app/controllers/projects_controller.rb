class ProjectsController < ApplicationController

  def index
    @projects = Project.paginate :page => params[:page], :per_page => 5, 
      :conditions => ["is_published=1"], :order => "position" 
  rescue Exception => e
    flash[:warning] = ERROR_MSG
    log_exception(e)
  end

  def show
    @project = Project.find :first, :conditions => ["id=? AND is_published=1", params[:id].to_i]
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
