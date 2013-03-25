class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.string :name, :null => false
			t.string :zip_code, :length => 5
			t.date   :birthday
			t.date   :other_date
			t.string :role
			t.string :email
			t.timestamps
		end
	end
end
