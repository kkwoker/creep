class CreateComment < ActiveRecord::Migration

  def change
    create_table :comments do |t|
      t.string :body
      t.integer :photo_id
      t.timestamps
    end
  end

end
