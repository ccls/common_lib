class Vendor < ActiveRecord::Base
	has_and_belongs_to_many :products, :foreign_key => 'unconventional_id'
	validations_from_yaml_file
end
