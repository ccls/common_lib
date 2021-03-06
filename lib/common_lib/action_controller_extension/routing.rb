module CommonLib::ActionControllerExtension::Routing

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def assert_no_route(verb,action,args={})
			test "#{brand}no route to #{verb} #{action} #{args.inspect}" do
#				assert_raise(ActionController::RoutingError){	#	rails 3
				assert_raise(ActionController::UrlGenerationError){	#	rails 4
					send(verb,action,args)
				}
			end
		end

	end	# module ClassMethods
end	#	module CommonLib::ActionControllerExtension::Routing
ActionController::TestCase.send(:include, 
	CommonLib::ActionControllerExtension::Routing)
