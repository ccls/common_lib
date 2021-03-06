require 'test_helper'

class VendorTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_attributes( :name )
	assert_should_require_attribute_length( :name, :in => 5..250 )
	assert_should_require_unique_attributes( :name )
	assert_should_habtm( :products )

	test "should be pending" do
		pending
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_vendor

end
