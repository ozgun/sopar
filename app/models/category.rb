class Category < ActiveRecord::Base
  has_many :articles, :dependent => :destroy
  
  validates_uniqueness_of :title, :message => "Category exists!"
  validates_presence_of :title
  
  before_destroy :dont_delete_last_category
    
  def dont_delete_last_category
    raise "Can't delete last category!" if Category.count == 1
  end
  
  def self.menu
    find :all, :order => "position"
  end
  
  def permalink
    "#{self.id}-#{self.title.gsub(/[^a-z0-9\-]/i, '-')}"
  end

end
