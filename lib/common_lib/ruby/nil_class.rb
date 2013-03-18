module CommonLib::NilClass	#	:nodoc:

	#	Return an empty array when attempting to split nil
	def split(*args)
		[]
	end

	def include?(*args)
		false
	end

end
NilClass.send( :include, CommonLib::NilClass )
