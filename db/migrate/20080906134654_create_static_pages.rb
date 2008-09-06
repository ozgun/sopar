class CreateStaticPages < ActiveRecord::Migration
  def self.up
    create_table :static_pages do |t|
      t.string :title
      t.text :body
      t.integer :is_published, :limit => 1, :default => 0
      t.timestamps
    end
    
    #About
    p = StaticPage.new(:title => "About Me", :body => "About me...")
    p.is_published = 1
    p.id = 1
    p.save!

    #Contact
    p = StaticPage.new(:title => "Contact", :body => "Contact info...")
    p.is_published = 1
    p.id = 2
    p.save!

    #Sample page
    p = StaticPage.new(:title => "Sample Page", :body => "sample page content... lorem ipsum...")
    p.is_published = 0
    p.id = 3
    p.save!
  end

  def self.down
    drop_table :static_pages
  end
end
