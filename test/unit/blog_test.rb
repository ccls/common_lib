require 'test_helper'

class BlogTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_attributes(:title)
	assert_should_require_attributes_not_nil(:title)
	assert_should_require_attribute_length(:title, :minimum => 5)
	assert_should_require_unique_attributes(:title)
#	assert_should_not_require_attributes(
#		:description)

	assert_should_protect_attributes(:limited_value)

#	assert_should_have_one(:addressing)
	assert_should_have_many(:posts)
	assert_should_initially_belong_to( :user, :foreign_key => 'owner_id' )

	assert_should_accept_only_good_values( :limited_value,
		{ :good_values => %w( apples oranges ) + [nil],
			:bad_values => %w( bananas grapefruit ) })

	test "should have blank blank_string" do
		#	testing assert_blank
		assert_blank ""
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_blog

end
