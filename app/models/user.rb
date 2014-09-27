class User < ActiveRecord::Base

	has_many :photos

	validates :username, presence: true, uniqueness: true
	validates :password, presence: true
end