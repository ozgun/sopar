class AddMenuToSitePref < ActiveRecord::Migration
  def self.up
    add_column :site_prefs, :menu, :text
    site_pref = SitePref.find :first
    site_pref.menu = '<a href="/">Blog</a>' + "\n" + 
                     '<a href="/projects">Projects</a>' + "\n" +
                     '<a href="/about">About</a>' + "\n" +
                     '<a href="/contact">Contact</a>'
    site_pref.save!
  end

  def self.down
    remove_column :site_prefs, :menu
  end
end
