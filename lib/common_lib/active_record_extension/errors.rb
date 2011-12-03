module CommonLib::ActiveRecordExtension::Errors
	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include,InstanceMethods)
	end
	module InstanceMethods
		#
		#	Can't believe this doesn't exist in rails.  It has proved very beneficial.
		#
		def on_attr_and_type(attribute,type)
			attribute = attribute.to_s
			return nil unless @errors.has_key?(attribute)
			@errors[attribute].collect(&:type).include?(type)
		end
		alias_method :on_attr_and_type?, :on_attr_and_type
	end
	module ClassMethods
		def delete(key)
			@errors.delete(key.to_s)
		end
	end
end	#	CommonLib::ActiveRecordExtension::Errors
ActiveRecord::Errors.send(:include,
	CommonLib::ActiveRecordExtension::Errors)
