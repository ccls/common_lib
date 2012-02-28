require 'test_helper'

class UserTest < ActiveSupport::TestCase

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

end
