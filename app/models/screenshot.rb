class Screenshot < ActiveRecord::Base
  belongs_to :project
  validates_associated :project
  has_attachment :storage => :file_system,
                 :max_size => 10.megabytes,
                 :content_type => :image,
                 :content_type_validation => true,
                 :processor => "Rmagick",
                 :thumbnails => { :thumb => '265x199>', :small => '100>' },
                 #:resize_to => '150x225>',
                 :path_prefix => 'public/images/screenshots'
  validates_as_attachment
end
