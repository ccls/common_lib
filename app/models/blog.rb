class Blog < ActiveRecord::Base

	belongs_to :user, :foreign_key => 'owner_id'
	has_many   :posts

	validations_from_yaml_file

end
