class CreateUsers < ActiveRecord::Migration
  def change

  	create_table :users do |t|
  		t.string :username
  		t.string :password

  	end

  	add_column :photos, :user_id, :integer
  end
end
