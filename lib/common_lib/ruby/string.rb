module CommonLib::String	#	:nodoc:

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
String.send( :include, CommonLib::String )
