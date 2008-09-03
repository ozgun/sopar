module Admin::SitePrefsHelper

  def delete_logo_link
    link_to_remote("Delete", :url => {:action => :delete_logo}) if logo_exists?
  end

end
