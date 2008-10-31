class Article < ActiveRecord::Base
  belongs_to :category, :counter_cache => true
  belongs_to :user
  has_many :comments, :dependent => :destroy
  named_scope :published, :conditions => {:is_published => 1}
  named_scope :unpublished, :conditions => {:is_published => 0}
  named_scope :sort_by_date_desc, :order => "created_at DESC" 
  named_scope :sort_by_is_published, :order => "is_published ASC" 
  named_scope :recent, lambda { |i| {:conditions => {:is_published => 1}, :order => "created_at DESC", :limit => (i || 5) } }

  acts_as_taggable

  #Allow only following attributes updated or created with mass-updates
  attr_accessible :title, :body, :tag_list, :category_id

  # Validations
  validates_presence_of :title
  validates_associated :category, :user

  def permalink
    "#{self.id}-#{self.title.gsub(/[^a-z0-9\-]/i, '-')}"
  end

  #TODO: Should be in a helper
  def status_description
    self.is_published == 1 ? "<font class=\"green\">Published</font>" : "<font class=\"red\">Un-published</font>"
  end

  #TODO: Should be in a helper
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

end
