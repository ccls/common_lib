module CommonLib::RailsExtension::ActionControllerExtension::Routing

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

#		def assert_route
#		end

		def assert_no_route(verb,action,args={})
			test "#{brand}no route to #{verb} #{action} #{args}" do
				assert_raise(ActionController::RoutingError){
					send(verb,action,args)
				}
			end
		end

	end	# module ClassMethods
end	#	module RailsExtension::ActionControllerExtension::Routing
ActionController::TestCase.send(:include, 
	CommonLib::RailsExtension::ActionControllerExtension::Routing)
