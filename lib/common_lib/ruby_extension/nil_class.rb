module CommonLib	#	:nodoc:
module RubyExtension	#	:nodoc:
module NilClass	#	:nodoc:
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods

		#	Return an empty array when attempting to split nil
		def split(*args)
			[]
		end

		def include?(*args)
			false
		end

	end

end
end
end
NilClass.send( :include, CommonLib::RubyExtension::NilClass )
