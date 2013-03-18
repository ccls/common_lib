require 'test_helper'

class CommonLib::NilClassTest < ActiveSupport::TestCase

#		def split(*args)
#		def include?(*args)

	test "should split nil and return empty array" do
		assert_equal [], nil.split()
	end

	test "should not include anything" do
		assert_equal false, nil.include?(1)
	end

end
