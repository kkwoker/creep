class Filename < ActiveRecord::Migration
  def change
    remove_column :photos, :url
    add_column :photos, :filename, :string
  end
end
