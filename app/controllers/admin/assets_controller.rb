class Admin::AssetsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @assets = Asset.paginate :page => params[:page], :per_page => 20, 
      :order => "assets.created_at DESC"
  end  
  def create
    asset = Asset.new({:uploaded_data => params[:uploaded_data]})
    #asset.user = current_user
    asset.save!
    flash[:notice] = "File uploaded."
    redirect_to :action => :index
  rescue Exception => e
    log_exception(e)
    flash[:warning] = "#{e.message}"
    redirect_to :action => :index
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    @id = @asset.id
    @asset.destroy
    respond_to do |format|
      format.js
    end
  end
  
end
