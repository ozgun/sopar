class Category < ActiveRecord::Base
  #has_many :articles, :dependent => :destroy
  
  validates_uniqueness_of :title, :message => "Category exists!"
  validates_presence_of :title
  
  before_destroy :dont_delete_default_category
    
  def dont_delete_default_category
    raise "Can't delete default category!" if self.id == 1
  end
  
  def self.menu
    find :all, :order => "position"
  end
  
end
