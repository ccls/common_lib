require 'test_helper'

class BlogTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_attributes(:title)
	assert_should_require_attribute_length(:title, :minimum => 5)
	assert_should_require_unique_attributes(:title)
#	assert_should_not_require_attributes(
#		:description)

#	assert_should_have_one(:addressing)
	assert_should_have_many(:posts)
	assert_should_initially_belong_to( :user, :foreign_key => 'owner_id' )


	test "should require some_blank_string to be blank" do
		blog = Factory.build(:blog,:some_blank_string => "I'm not blank")
		assert !blog.valid?
		assert blog.errors.matching?(:some_blank_string,
			"is present and must be absent"), blog.errors.full_messages.to_sentence
	end

	test "should have blank blank_string" do
		#	testing assert_blank
		assert_blank ""
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_blog

end
