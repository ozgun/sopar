class StaticPage < ActiveRecord::Base
  before_destroy :dont_destroy_contact_and_about

  named_scope :published, :conditions => {:is_published => 1}
  named_scope :unpublished, :conditions => {:is_published => 0}
  named_scope :sort_by_date_desc, :order => "created_at DESC" 
  named_scope :sort_by_is_published, :order => "is_published ASC" 

  def dont_destroy_contact_and_about
    raise "Error! Can't delete default pages!" if (self.id == 1 or self.id == 2)
  end
  
  #Allow only following attributes updated or created with mass-updates
  attr_accessible :title, :body

  # Validations
  validates_presence_of :title

  def permalink
    "#{self.id}-#{self.title.gsub(/[^a-z0-9\-]/i, '-')}"
  end

  #TODO: Should be in a helper.
  def status_description
    self.is_published == 1 ? "<font class=\"green\">Published</font>" : "<font class=\"red\">Un-published</font>"
  end

  def change_publish_status(new_status)
    self.is_published = new_status
    self.save!
  rescue Exception => e
    raise e
  end

end
