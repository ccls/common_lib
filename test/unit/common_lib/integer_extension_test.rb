require 'test_helper'

class CommonLib::IntegerExtensionTest < ActiveSupport::TestCase

#		def factorial

	test "should return 5 factorial" do
		assert_equal 120, 5.factorial
	end

	test "should return 0 factorial" do
		assert_equal 0, 0.factorial
	end

	test "should return -3 factorial" do
		assert_equal -3, -3.factorial
	end

end
