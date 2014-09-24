class TagIdAddition < ActiveRecord::Migration
  def change
    remove_column :photos, :tag
    add_column :photos, :tag_id, :integer

end
end
