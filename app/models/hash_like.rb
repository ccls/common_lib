class HashLike < ActiveRecord::Base
	acts_like_a_hash(:value => :value)
end
