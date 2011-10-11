module CommonLib; end

require "common_lib/object_extension"
require "common_lib/integer_extension"
require "common_lib/array_extension"
require "common_lib/string_extension"
require "common_lib/hash_extension"
require "common_lib/nil_class_extension"

def brand	#	for auto-generated tests
	"@@ "
end
require 'common_lib/active_support_extension'
require 'common_lib/active_record_extension'
require 'common_lib/action_controller_extension'
require 'common_lib/action_view_extension'
