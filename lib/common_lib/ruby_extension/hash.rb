module CommonLib	#	:nodoc:
module RubyExtension	#	:nodoc:
module Hash	#	:nodoc:
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods

		#	delete all keys matching the given regex
		#	and return the new hash
		def delete_keys_matching!(regex)
			self.keys.each do |k| 
				if k.to_s =~ Regexp.new(regex)
					self.delete(k)
				end 
			end 
			self
		end 

		#	delete all keys in the given array
		#	and return the new hash
		def delete_keys!(*keys)
			keys.each do |k| 
				self.delete(k)
			end 
			self
		end 

		#	params.dig('study_events',se.id.to_s,'eligible')
		def dig(*args)
			if args.length > 0 && self.keys.include?(args.first)
				key = args.shift
				if args.length > 0 
					if self[key].is_a?(Hash)
						self[key].dig(*args)
					else
						nil
					end
				else
					self[key]
				end
			end
		end

	end

end
end
end
Hash.send( :include, CommonLib::RubyExtension::Hash )
