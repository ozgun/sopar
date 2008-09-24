class Article < ActiveRecord::Base
  belongs_to :category, :counter_cache => true
  belongs_to :user
  has_many :comments, :dependent => :destroy

  acts_as_taggable

  #Allow only following attributes updated or created with mass-updates
  attr_accessible :title, :body, :tag_list, :category_id

  # Validations
  validates_presence_of :title
  validates_associated :category, :user

  def permalink
    "#{self.id}-#{self.title.gsub(/[^a-z0-9\-]/i, '-')}"
  end

  def status_description
    self.is_published == 1 ? "<font class=\"green\">Published</font>" : "<font class=\"red\">Un-published</font>"
  end

  def comments_status_description
    self.comments_closed == 0 ? "<font class=\"green\">Allowed</font>" : "<font class=\"red\">Closed</font>"
  end
  
  
  def change_publish_status(new_status)
    self.is_published = new_status
    self.save!
  rescue Exception => e
    raise e
  end

  def change_comments_status(new_status)
    self.comments_closed = new_status
    self.save!
  rescue Exception => e
    raise e
  end

  #def self.simple_search(p)
  #  find_tagged_with(p[:q]).paginate :page => p[:page], :per_page => 10,
  #    :conditions => ["is_published=1 AND category_id>1"],
  #    :order => "articles.created_at DESC", :include => [:user]
  #end


  def self.published
    find :all, :conditions => ["is_published=1"]
  end

  def self.ordered
    find :all, :order => "created_at DESC" 
  end

  def self.recent
    published.find :first, :order => "created_at DESC"
  end

  def self.latest_articles
    find :all, :conditions => ["is_published=1"], :order => "created_at DESC", :limit => 5
  end

end
