class Validator < ActiveRecord::Base

	#	tests the validations file
	validations_from_yaml_file

	#	also test explicit call from model
	validates_absence_of :absence_1
	validates_past_date_for :past_date_1
	validates_past_date_for :past_date_3, :allow_today => false
	validates_complete_date_for :complete_date_1

end
