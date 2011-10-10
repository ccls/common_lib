class CreateBlogs < ActiveRecord::Migration
	def self.up
		create_table :blogs do |t|
			t.integer :owner_id
			t.integer :posts_count, :default => 0
			t.string :title
			t.timestamps
		end
	end

	def self.down
		drop_table :blogs
	end
end
