class CreateFormModels < ActiveRecord::Migration
	def change
		create_table :form_models do |t|
			t.integer :integer_field
			t.date :date_field
			t.datetime :datetime_field
			t.string :string_field
			t.boolean :boolean_field
			t.timestamps
		end
	end
end
