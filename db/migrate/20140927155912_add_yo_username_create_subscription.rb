class AddYoUsernameCreateSubscription < ActiveRecord::Migration
  def change
  	create_table :tag_subscriptions do |t|
  		t.integer :user_id
  		t.integer :tag_id

  	end

  	add_column :users, :yo_username, :string

  end
end
