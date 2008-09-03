class Admin::SitePrefsController < ApplicationController
  layout "admin"
  before_filter :login_required

  def edit
    @site_pref = SitePref.find :first
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
    redirect_to "/"
  end

  def update
    @site_pref = SitePref.find :first
    upload_file(params[:site_pref][:logo], "", "logo.png") unless params[:site_pref][:logo].blank? 
    @site_pref.update_attributes!(params[:site_pref])
    flash[:notice] = "Site preferences updated."
    redirect_to edit_admin_site_pref_url(@site_pref)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    log_exception(e)
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
    redirect_to edit_admin_site_pref_url(@site_pref)
  end

  def delete_logo
    delete_file("public/images/logo.png")
    flash[:notice] = "Logo deleted."
    respond_to do |format|
      format.js
    end
  rescue Exception => e
    flash[:warning] = "Error! Couldn't delete logo!"
    log_exception(e)
    respond_to do |format|
      format.js
    end
  end

end
