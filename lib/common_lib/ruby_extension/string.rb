module CommonLib	#	:nodoc:
module RubyExtension	#	:nodoc:
module String	#	:nodoc:
  def self.included(base)
#    base.extend(ClassMethods)
    base.instance_eval do
      include InstanceMethods
    end
  end

#  module ClassMethods	#	:nodoc:
#  end

  module InstanceMethods

		#	Convert a query string like that in a URL
		#	to a Hash
		def to_params_hash
			h = HashWithIndifferentAccess.new
			self.split('&').each do |p|
				(k,v) = p.split('=',2)
				h[k] = URI.decode(v)
			end
			return h
		end

		#	Return self
		def uniq
			self
		end

  end

end
end
end
String.send( :include, CommonLib::RubyExtension::String )
