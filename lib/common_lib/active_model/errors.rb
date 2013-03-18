class ActiveModel::Errors
#module ActiveModelExtension::Errors
#	def self.included(base)
#		base.extend(ClassMethods)
#		base.send(:include,InstanceMethods)
#	end
#	module InstanceMethods

		def matching?(attribute,message)
#>> a.errors.messages[:cbc_report_found]
#=> ["is not included in the list"]
#>> a.errors.messages[:cbc_report_found].any?{|m| m.match(/include/)}
#=> true
#>> a.errors.messages[:cbc_report_found].any?{|m| m.match(/inclue/)}
#=> false
			#	all keys seem to be converted to symbols? NOT indifferent.
			self.include?(attribute.to_sym) &&
				self.messages[attribute.to_sym].any?{|m| m.match(/#{message.to_s}/) }
#				@messages[attribute.to_sym].any?{|m| m.match(/#{message.to_s}/) }
		end

#	end
#	module ClassMethods
#	end
end	#	ActiveModelExtension::Errors
#ActiveModel::Errors.send(:include,ActiveModelExtension::Errors)
