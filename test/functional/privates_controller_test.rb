require 'test_helper'

class PrivatesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Private',
		:actions => [:new,:create,:edit,:update,:show,:index,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_private
	}

	def create_private(options={})
		Private.create(options)
	end

	def factory_attributes(options={})
		Factory.attributes_for(:private,options)
	end

	assert_access_with_login({    :logins => site_administrators })
	assert_no_access_with_login({ :logins => non_site_administrators })
	assert_no_access_without_login

protected

	alias_method :create_object, :create_private

end
