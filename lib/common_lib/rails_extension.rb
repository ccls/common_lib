def brand	#	for auto-generated tests
	"@@ "
end
module CommonLib::RailsExtension
#	predefine namespaces
	module ActiveSupportExtension
	end
	module ActiveRecordExtension
	end
	module ActionControllerExtension
	end
end
#
#	This may require the addition of other gem requirements
#
require 'common_lib/rails_extension/active_support_extension'
require 'common_lib/rails_extension/active_record_extension'
require 'common_lib/rails_extension/action_controller_extension'
