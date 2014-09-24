class Photo < ActiveRecord::Base

  has_many :comments
   has_one :tag
end
