class AddSomeBlankStringToBlog < ActiveRecord::Migration
	def change
		add_column :blogs, :some_blank_string, :string
	end
end
