class Comment < ActiveRecord::Base
  belongs_to :article, :counter_cache => true

  named_scope :published, :conditions => {:is_published => 1}
  named_scope :unpublished, :conditions => {:is_published => 0}
  named_scope :sort_by_date_desc, :order => "created_at DESC" 
  named_scope :sort_by_is_published, :order => "is_published ASC" 
  named_scope :sort_by_is_published_and_date_desc, :order => "is_published ASC, created_at DESC" 
  named_scope :recent, lambda { |i| {:conditions => {:is_published => 1}, :order => "created_at DESC", :limit => (i || 5) } }

  #Allow only following attributes updated or created with mass-updates
  attr_accessible :title, :body, :commentator, :commentator_email, :commentator_website

  # Validations
  validates_presence_of :body, :commentator
  validates_associated :article

  #TODO: Should be in a helper.
  def status_description
    self.is_published == 1 ? "<font class=\"green\">Published</font>" : "<font class=\"red\">Un-published</font>"
  end
  
  def change_publish_status(new_status)
    self.is_published = new_status
    self.save!
    self.article.increment!(:comments_published) if new_status == 1
    self.article.decrement!(:comments_published) if new_status == 0
  rescue Exception => e
    raise e
  end

end
