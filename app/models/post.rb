class Post < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'author_id'
	acts_as_list :scope => :blog_id
	belongs_to :blog, :counter_cache => true
	validations_from_yaml_file
	nilify_if_blank :body
end
