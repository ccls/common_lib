require 'test_helper'

class UserTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_require_attributes( :name )
	assert_should_require_attribute_length( :name, :in => 5..250 )
	assert_should_require_unique_attributes( :name )
	assert_should_require_attributes( :zip_code )
	assert_should_require_attribute_length( :zip_code, :is => 5 )
	assert_should_have_one( :blog )	#, :foreign_key => 'owner_id'	)
	assert_should_have_many( :posts )	#, :foreign_key => 'author_id'	)

	assert_should_not_require(:birthday)
	assert_requires_complete_date(:birthday)
	assert_requires_past_date(:birthday)	#	:allow_today => true is default

	assert_should_not_require(:other_date)
	assert_requires_past_date(:other_date, :allow_today => false)


	test "should have aliased username to name" do
		user = Factory(:user)
		assert_equal user.name, user.username
	end

	test "should include username in aliased_attributes" do
		assert User.aliased_attributes.has_key?(:username),
			User.aliased_attributes.keys.join(',')
		assert User.aliased_attributes.has_key?('username'),
			User.aliased_attributes.keys.join(',')
	end

	test "should have blank random without any" do
		assert User.random.blank?
	end

	test "should return only user with random" do
		user = Factory(:user)
		assert_equal user, User.random
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_user

end
