class CreateSitePrefs < ActiveRecord::Migration
  def self.up
    create_table :site_prefs do |t|
      t.string :title, :slogan, :email, :domain, :feedburner, :recaptcha_public_key, :recaptcha_private_key
      t.text :footer, :sidebar, :google_analytics, :google_adsense, :gtalk_badge, 
             :links, :twitter, :addthis, :delicious, :workingwithrails, :feed_description
      t.integer :show_projects, :limit => 1, :default => 0
      t.timestamps
    end
    p = SitePref.new :title => "My Title", 
                 :slogan => "My slogan goes here", 
                 :email => "admin@example.com",
                 :domain => "example.com",
                 :footer => "Copyleft 2008",
                 :feed_description => "Feed description",
                 :sidebar => "sidebar extra content",
                 :google_analytics => "",
                 :google_adsense => "",
                 :gtalk_badge => "",
                 :addthis => "",
                 :delicious => "",
                 :feedburner => "",
                 :workingwithrails => "",
                 :links => "<a href=\"http://google.com\">google.com</a>",
                 :recaptcha_public_key => "",
                 :recaptcha_private_key => ""
    p.save!
  end

  def self.down
    drop_table :site_prefs
  end
end
