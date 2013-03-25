class CreateBlogs < ActiveRecord::Migration
	def change
		create_table :blogs do |t|
			t.integer :owner_id
			t.integer :posts_count, :default => 0
			t.string :title
			t.boolean :some_flag
			t.string :limited_value
		end
	end
end
