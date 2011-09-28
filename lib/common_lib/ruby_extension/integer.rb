module CommonLib	#	:nodoc:
module RubyExtension	#	:nodoc:
module Integer	#	:nodoc:
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods

		#	Return n!
		def factorial
			f = n = self
			f *= n -= 1 while( n > 1 )
			return f
		end

	end

end
end
end
Integer.send( :include, CommonLib::RubyExtension::Integer )
