class AddLimitedValueToBlog < ActiveRecord::Migration
	def change
		add_column :blogs, :limited_value, :string
	end
end
