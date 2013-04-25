class Blog < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'owner_id'
	has_many   :posts
	attr_protected :limited_value	#	protect to check 'good values' test
	validations_from_yaml_file
end
