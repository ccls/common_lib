class AddSomeFlagToBlog < ActiveRecord::Migration
	def change
		add_column :blogs, :some_flag, :boolean
	end
end
