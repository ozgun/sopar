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
    @site_pref.update_attributes!(params[:site_pref])
    flash[:notice] = "Site preferences updated."
    redirect_to edit_admin_site_pref_url(@site_pref)
  rescue Exception => e
    flash[:warning] = "Error!"
    log_exception(e)
    #redirect_to edit_admin_site_pref_url(@site_pref)
  end

end
