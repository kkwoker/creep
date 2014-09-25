class ChangeTitleName < ActiveRecord::Migration
  def change
    remove_column :photos, :photo_title
    add_column :photos, :title, :string
  end
end
