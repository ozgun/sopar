class Asset < ActiveRecord::Base
  has_attachment :storage => :file_system,
                 :max_size => 10.megabytes,
                 #:content_type_validation => true,
                 :processor => "Rmagick",
                 :path_prefix => 'public/uploads'
  validates_as_attachment
end
