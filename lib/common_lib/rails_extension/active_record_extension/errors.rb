module CommonLib::RailsExtension::ActiveRecordExtension::Errors
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include,InstanceMethods)
	end
	module InstanceMethods
		def on_attr_and_type(attribute,type)
			attribute = attribute.to_s
			return nil unless @errors.has_key?(attribute)
			@errors[attribute].collect(&:type).include?(type)
		end
	end
	module ClassMethods
		def delete(key)
			@errors.delete(key.to_s)
		end
	end
end	#	RailsExtension::ActiveRecordExtension::Errors
ActiveRecord::Errors.send(:include,
	CommonLib::RailsExtension::ActiveRecordExtension::Errors)
