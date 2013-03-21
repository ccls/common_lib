class Product < ActiveRecord::Base
	has_and_belongs_to_many :vendors, :association_foreign_key => 'unconventional_id'

	validations_from_yaml_file

#	validates_length_of :name, :in => 5..250

end
