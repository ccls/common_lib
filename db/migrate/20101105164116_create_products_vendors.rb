class CreateProductsVendors < ActiveRecord::Migration
	def self.up
		create_table :products_vendors, :id => false do |t|
			t.integer :product_id
			t.integer :unconventional_id
		end
		add_index :products_vendors, :product_id
		add_index :products_vendors, :unconventional_id
	end

	def self.down
		drop_table :products_vendors
	end
end
