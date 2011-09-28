module CommonLib	#	:nodoc:
module RubyExtension	#	:nodoc:
module Object	#	:nodoc:
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods
#
#		#	originally from ActiveSupport::Callbacks::Callback
##	needs modified to actually work the way I'd like
##	needs tests
##	x(:some_method)
##	x(Proc.new(....))
##	x(lambda{...})
#		#	def evaluate_method(method, *args, &block)
#		def evaluate_method(method, *args, &block)
#			case method
#				when Symbol
##		I don't quite understand the shift (it fails)
##					object = args.shift
##					object.send(method, *args, &block)
#					send(method, *args, &block)
#				when String
#					eval(method, args.first.instance_eval { binding })
#				when Proc, Method
##	fails
#					method.call(*args, &block)
#				else
#					if method.respond_to?(kind)
#						method.send(kind, *args, &block)
#					else
#						raise ArgumentError,
#							"Callbacks must be a symbol denoting the method to call, a string to be evaluated, " +
#							"a block to be invoked, or an object responding to the callback method."
#					end
#				end
#		end
#		alias_method :x, :evaluate_method
#
#		def to_boolean
##			return [true, 'true', 1, '1', 't'].include?(
#			return ![nil, false, 'false', 0, '0', 'f'].include?(
#				( self.is_a?(String) ) ? self.downcase : self )
#		end
#
#		#	looking for an explicit true
#		def true?
#			return [true, 'true', 1, '1', 't'].include?(
#				( self.is_a?(String) ) ? self.downcase : self )
#		end
#
#		#	looking for an explicit false (not nil)
#		def false?
#			return [false, 'false', 0, '0', 'f'].include?(
#				( self.is_a?(String) ) ? self.downcase : self )
#		end
#
	end

end
end
end
Object.send(:include, CommonLib::RubyExtension::Object)
