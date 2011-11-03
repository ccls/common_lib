module CommonLib::ActiveRecordExtension::Error
#
#	def self.included(base)
#		base.alias_method_chain( :generate_full_message, :attribute_strip ) unless
#			base.method_defined?(:generate_full_message_without_attribute_strip)
#	end
#
#	def generate_full_message_with_attribute_strip(options = {}, &block)
#		m = generate_full_message_without_attribute_strip(options, &block)
#		unless( ( i = m.index('<|X|') ).nil? )
#			m = m[i+4..-1]
#		end
#		m
#	end
#	
end	#	module CommonLib::ActiveRecordExtension::Error
#ActiveRecord::Error.send(:include,
#	CommonLib::ActiveRecordExtension::Error)

#	We do not use this anymore.  I wrote custom validations that
#	effectively do the same thing and much cleaner.
