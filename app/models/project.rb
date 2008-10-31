class Project < ActiveRecord::Base
  has_many :screenshots, :dependent => :destroy

  named_scope :published, :conditions => {:is_published => 1}
  named_scope :unpublished, :conditions => {:is_published => 0}
  named_scope :sort_by_date_desc, :order => "created_at DESC" 
  named_scope :sort_by_is_published, :order => "is_published ASC" 
  named_scope :sort_by_position, :order => "position ASC" 
  named_scope :latest_projects, lambda { |i| {:conditions => {:is_published => 1}, :order => "position", :limit => (i || 3) } }
  
  # Validations
  validates_presence_of :title

  #virtual attribute for screenshots 
  def screenshot_attributes=(screenshot_attributes)
    screenshot_attributes.each do |attributes|
      screenshots.build(attributes) unless attributes[:uploaded_data].blank?
    end
  end

  def permalink
    "#{self.id}-#{self.title.gsub(/[^a-z0-9\-]/i, '-')}"
  end

  def change_publish_status(new_status)
    self.is_published = new_status
    self.save!
  rescue Exception => e
    raise e
  end

end
