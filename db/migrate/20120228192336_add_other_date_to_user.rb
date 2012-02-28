class AddOtherDateToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :other_date, :date
	end

	def self.down
		remove_column :users, :other_date
	end
end
