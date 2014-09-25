class RemoveTagIdFromPhotos < ActiveRecord::Migration
  def change
  	remove_column :photos, :tag_id
  end
end
