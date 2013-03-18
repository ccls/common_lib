module CommonLib; end

require "common_lib/ruby"

def brand	#	for auto-generated tests
	"@@ "
end
require 'common_lib/active_support_extension'
#require 'common_lib/active_record_extension'
require 'common_lib/active_model'
require 'common_lib/active_record'
require 'common_lib/action_controller_extension'
require 'common_lib/action_view_extension'


#	pretty much always as don't expect this to be used outside of a rails app
require 'common_lib/railtie' if defined?(Rails)

