class Photo < ActiveRecord::Base


  has_many :comments
  has_and_belongs_to_many :tags
  belongs_to :user
  has_many :rated_photos
  def most_recent_comment
    if !self.comments.empty?
      self.comments.order(:created_at).last
    end
  end

end
