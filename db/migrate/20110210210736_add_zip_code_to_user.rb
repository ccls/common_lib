class AddZipCodeToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :zip_code, :string, :length => 5
	end

	def self.down
		remove_column :users, :zip_code
	end
end
