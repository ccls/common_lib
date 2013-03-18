require 'test_helper'

class CommonLib::StringTest < ActiveSupport::TestCase

#		def to_params_hash
#		def uniq

	test "should convert url query string to hash" do
		h = {'foo' => '1', 'bar' => '2'}
		assert_equal h, "foo=1&bar=2".to_params_hash
	end

	test "should return self in response to uniq" do
		assert_equal "foobar", "foobar".uniq
	end

end
