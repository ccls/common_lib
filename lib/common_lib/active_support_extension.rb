module CommonLib::ActiveSupportExtension; end
if defined?(Rails) and Rails.env == 'test'
require 'common_lib/active_support_extension/test_case'
require 'common_lib/active_support_extension/associations'
require 'common_lib/active_support_extension/assertions'
require 'common_lib/active_support_extension/attributes'

#	due to the complications of rake and autotest using
#	differing versions of Test::Unit and MiniTest
#	I have modified and am reincluding pending
require 'common_lib/active_support_extension/pending'
end
