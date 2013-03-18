module CommonLib::Integer	#	:nodoc:

	#	Return n!
	def factorial
		f = n = self
		f *= n -= 1 while( n > 1 )
		return f
	end

end
Integer.send( :include, CommonLib::Integer )
