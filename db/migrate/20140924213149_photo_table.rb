class PhotoTable < ActiveRecord::Migration

  def change
    create_table :photos do |t|
      t.string :tag
      t.string :url
      t.string :photo_title
      t.integer :rating
      t.timestamps
    end
  end

end
