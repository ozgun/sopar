class StaticPage < ActiveRecord::Base
  before_destroy :dont_destroy_contact_and_about

  def dont_destroy_contact_and_about
    raise "Error! Can't delete default pages!" if (self.id == 1 or self.id == 2)
  end
  
  #Allow only following attributes updated or created with mass-updates
  attr_accessible :title, :body

  # Validations
  validates_presence_of :title

  def permalink
    "#{self.id}-#{self.title}"
  end

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
