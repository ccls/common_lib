require 'test_helper'

class HashLikeTest < ActiveSupport::TestCase

	assert_should_behave_like_a_hash(:value => :value)

protected

	# create_object is called from within the common class tests
	alias_method :create_object, :create_hash_like

end
