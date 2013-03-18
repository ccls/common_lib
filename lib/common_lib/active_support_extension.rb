require 'active_support'
require 'active_support/test_case'

module CommonLib::ActiveSupportExtension; end
require 'common_lib/active_support_extension/test_case'
require 'common_lib/active_support_extension/test_with_verbosity'
require 'common_lib/active_support_extension/associations'
require 'common_lib/active_support_extension/assertions'
require 'common_lib/active_support_extension/attributes'
#require 'common_lib/active_support_extension/pending'


Rails.backtrace_cleaner.add_silencer {|line|
#	line =~ /\/test\/.*\.\.\/declarative\.rb:/
#	Due to my modification, every error is accompanied by 
#		3 additional and unnecessary lines like ...
#	/test/functional/../declarative.rb:21:in `_test_should_change_locale_to_es_without_verbosity'
#/test/functional/../declarative.rb:21:in `send'
#/test/functional/../declarative.rb:21:in `_test_should_change_locale_to_es_with_verbosity']:
#
#	in rvm/jruby the error is passing through
#	test/declarative.rb:21:in `_test_should_NOT_create_new_user_if_invitation_update_fails_with_verbosity']:

#     /Users/jakewendt/github_repo/jakewendt/ucb_ccls_clic/vendor/plugins/ucb_ccls_engine/rails/../test/helpers/declarative.rb:21:in `_test_AWiHTTP_should_get_show_with_admin_login_with_verbosity'

#	This doesn't seem to work at all in the plugin engine.
#	line =~ /test.*\/declarative\.rb:/
#	line =~ /simply_testable\/declarative\.rb:/

#	Return true or false.  Need to collect if adding multiple conditions.
#	line =~ /common_lib\/active_support_extension\/test_case\.rb:/



	line =~ /test_with_verbosity/

} if defined? Rails 
