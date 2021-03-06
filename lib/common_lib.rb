#	because HashWithIndifferentAccess is just too long a name
HWIA = HashWithIndifferentAccess

module CommonLib; end

require "common_lib/ruby"
require "common_lib/translation_table"

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
if defined?(Rails)
require 'common_lib/railtie' 
require 'common_lib/engine' 
end






require 'hpricot'
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| 
	error_class = 'field_error'
	nodes = Hpricot(html_tag)
	nodes.each_child { |node| 
		node[:class] = node.classes.push(error_class).join(' ') unless !node.elem? || node[:type] == 'hidden' || node.classes.include?(error_class) 
	}
	nodes.to_html.html_safe
}

