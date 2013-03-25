class CreatePosts < ActiveRecord::Migration
	def change
		create_table :posts do |t|
			t.integer    :author_id
			t.references :blog
			t.integer :position, :default => 0
			t.string :title
			t.text :body
			t.timestamps
		end
	end
end
