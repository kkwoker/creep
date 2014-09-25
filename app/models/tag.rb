class Tag < ActiveRecord::Base
	has_many :photos
	validates :name, uniqueness: true
end
