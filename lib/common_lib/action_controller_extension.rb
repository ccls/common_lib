module CommonLib::ActionControllerExtension; end
if defined?(Rails) and Rails.env == 'test'
require 'common_lib/action_controller_extension/test_case'
#	I don't bother testing http versus https in rails 3
#require 'common_lib/action_controller_extension/accessible_via_protocol'
require 'common_lib/action_controller_extension/accessible_via_user'
require 'common_lib/action_controller_extension/routing'
end
