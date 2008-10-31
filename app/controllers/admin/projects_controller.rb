class Admin::ProjectsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @projects = Project.sort_by_position.sort_by_date_desc.paginate :per_page => 10, :page => params[:page]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def new
    @project = Project.new
    5.times { @project.screenshots.build }
  end

  def create
    @project = Project.new(params[:project])
    @project.save!
    flash[:notice] = "Project created"
    redirect_to admin_project_url(@project)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :new
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
    redirect_to :action => :new
  end

  def show
    @project = Project.find params[:id]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def edit
    @project = Project.find params[:id]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def update
    @project = Project.find params[:id]
    @project.update_attributes!(params[:project])
    flash[:notice] = "Project updated"
    redirect_to admin_project_url(@project)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :edit, :id => @project
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to admin_projects_url
  end

  def destroy
    @project = Project.find params[:id]
    @id = @project.id
    @project.destroy
    flash[:notice] = "Project deleted"
    respond_to do |format|
      format.html { redirect_to admin_projects_url }
      format.js
    end
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    respond_to do |format|
      format.html { redirect_to admin_projects_url }
      format.js
    end
  end


  #TODO: Do it with AJAX
  def publish
    @project = Project.find(params[:id])
    @project.change_publish_status(1)
    flash[:notice] = "Project status changed to published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :back
  end
  
  #TODO: Do it with AJAX
  def unpublish
    @project = Project.find(params[:id])
    @project.change_publish_status(0)
    flash[:notice] = "Project status changed to un-published."
    redirect_to :back
  rescue Exception => e
    log_exception(e)
    flash[:warning] = e.message
    redirect_to :back
  end

  def reposition
    @projects = Project.find :all, :order => "position"
  end

  def order
    params[:my_list].each_with_index do |id, position|
      Project.update(id, :position => position) 
    end
    flash[:notice] = "Projects repositioned"
    respond_to do |format|
      format.js
    end
  end

  def new_screenshots
    @project = Project.find params[:id]
    @screenshots = [Screenshot.new, Screenshot.new, Screenshot.new ]
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
  end

  def create_screenshots
    @project = Project.find params[:id]
    @project.update_attributes!(params[:project])
    flash[:notice] = "Screenshots added"
    redirect_to admin_project_url(@project)
  rescue ActiveRecord::RecordInvalid => e
    @project = Project.find params[:id]
    flash[:warning] = e.message
    #render :action =>  :new_screenshots, :id => @project
    redirect_to :action => :new_screenshots, :id => @project
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
    redirect_to :action => :index
  end

end
