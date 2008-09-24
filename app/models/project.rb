class Project < ActiveRecord::Base
  has_many :screenshots, :dependent => :destroy
  
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

  def self.published
    find :all, :conditions => ["is_published=1"]
  end

  def self.latest_projects
    find :all, :conditions => ["is_published=1"], :order => "position", :limit => 3 
  end

end
