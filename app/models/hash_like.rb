class HashLike < ActiveRecord::Base
#	attr_accessible :key, :value
	acts_like_a_hash(:value => :value)
end
