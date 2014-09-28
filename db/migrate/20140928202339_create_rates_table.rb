class CreateRatesTable < ActiveRecord::Migration
  def change
  	create_table :rates do |t|
  		t.integer :user_id
  		t.integer :photo_id
  		t.integer :value
  	end
  end
end
