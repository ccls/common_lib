require 'test_helper'

class ValidatorTest < ActiveSupport::TestCase

	assert_should_create_default_object

#	assert_requires_absence(:absence_1)
#	assert_requires_absence(:absence_2)
	assert_requires_past_date(:past_date_1)
	assert_requires_past_date(:past_date_2)
	assert_requires_past_date(:past_date_3, :allow_today => false)
	assert_requires_past_date(:past_date_4, :allow_today => false)
	assert_requires_complete_date(:complete_date_1)
	assert_requires_complete_date(:complete_date_2)

	test "should require absence of absence_1" do
		validator = FactoryGirl.build(:validator,:absence_1 => "I'm not blank")
		assert !validator.valid?
		assert validator.errors.matching?(:absence_1,
			"is present and must be absent"), validator.errors.full_messages.to_sentence
	end

	test "should require absence of absence_2" do
		validator = FactoryGirl.build(:validator,:absence_2 => "I'm not blank")
		assert !validator.valid?
		assert validator.errors.matching?(:absence_2,
			"is present and must be absent"), validator.errors.full_messages.to_sentence
	end

protected

	def create_validator(options={})
		validator = FactoryGirl.build(:validator,options)
		validator.save
		validator
	end

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_validator

end
