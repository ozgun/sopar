class CreateSitePrefs < ActiveRecord::Migration
  def self.up
    create_table :site_prefs do |t|
      t.string :title, :slogan, :email, :domain
      t.text :footer, :sidebar, :google_analytics, :google_adsense, :gtalk_badge, :links
      t.timestamps
    end
    p = SitePref.new :title => "My Title", 
                 :slogan => "My slogan goes here", 
                 :email => "admin@example.com",
                 :domain => "example.com",
                 :footer => "Copyleft 2008",
                 :sidebar => "sidebar extra content",
                 :google_analytics => "",
                 :google_adsense => "",
                 :gtalk_badge => "",
                 :links => "<a href=\"http://google.com\">google.com</a>"
    p.save!
  end

  def self.down
    drop_table :site_prefs
  end
end
