#	separated out this so could modify without 
#	always restarting all the tests.
#
#	This isn't even coming close to 100%
#	It is showing most things as untested which is confusing.
#
require 'simplecov'
SimpleCov.start 'rails' do
	add_filter 'lib/common_lib/railtie.rb'
	add_filter 'lib/common_lib/active_support_extension.rb'
#	add_filter 'lib/method_missing_with_authorization.rb'
#	add_filter 'lib/ucb_ldap-1.4.2'
	merge_timeout 72000
end
#
#	I would really like to figure out how to include the views!
#	Apparently, can't (don't like that word) because the coverage
#	monitor is triggered by the "require" call.  Perhaps I can
#	figure out how to "require" all of the views?
#
