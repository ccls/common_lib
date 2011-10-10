class Post < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'author_id'
	acts_as_list :scope => :blog_id
	belongs_to :blog, :counter_cache => true
	validates_presence_of :title
	validates_length_of   :title, :maximum => 250
	validates_presence_of :blog, :blog_id
end
