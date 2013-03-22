class CreatePrivates < ActiveRecord::Migration
	def change
		create_table :privates do |t|
			t.string :name
			t.timestamps
		end
	end
end
