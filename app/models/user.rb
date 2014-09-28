class User < ActiveRecord::Base

	has_many :photos
	has_many :tag_subscriptions
	validates :username, presence: true, uniqueness: true
	validates :password, presence: true
end