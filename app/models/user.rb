class User < ActiveRecord::Base
	has_one  :blog,  :foreign_key => 'owner_id'
	has_many :posts, :foreign_key => 'author_id'

	validations_from_yaml_file

	alias_attribute :username, :name

	attr_protected :role

end
