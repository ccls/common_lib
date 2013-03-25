class CreateValidators < ActiveRecord::Migration
	def change
		create_table :validators do |t|
			t.string :absence_1
			t.string :absence_2
			t.date :complete_date_1
			t.date :complete_date_2
			t.date :past_date_1
			t.date :past_date_2
			t.date :past_date_3
			t.date :past_date_4
			t.timestamps
		end
	end
end
