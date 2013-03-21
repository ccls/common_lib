class CreateHashLikes < ActiveRecord::Migration
	def change
		create_table :hash_likes do |t|
			t.string :key
			t.string :value
			t.timestamps
		end
	end
end
