class Blog < ActiveRecord::Base
	belongs_to :user, :foreign_key => 'owner_id'
	has_many   :posts
	validates_presence_of   :title
	validates_length_of     :title, :minimum => 5
	validates_uniqueness_of :title
	validates_presence_of   :user, :owner_id
end
