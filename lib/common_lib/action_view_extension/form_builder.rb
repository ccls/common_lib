module CommonLib::ActionViewExtension::FormBuilder

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain( :method_missing, :field_wrapping 
				) unless base.respond_to?(:method_missing_without_field_wrapping)
		end
	end

	module InstanceMethods

		def submit_link_to(value=nil,options={})
			#	submit_link_to will remove :value, which is intended for submit
			#	so it MUST be executed first.  Unfortunately, my javascript
			#	expects it to be AFTER the a tag.
	#		s = submit(value,options.reverse_merge(
	#				:id => "#{object_name}_submit_#{value.try(:downcase).try(:gsub,/\s+/,'_')}"
	#			) ) << @template.submit_link_to(value,nil,options)
			s1 = submit(value,options.reverse_merge(
					:id => "#{object_name}_submit_#{value.try(:downcase).try(
						:gsub,/\s+/,'_').try(
						:gsub,/(&amp;|'|\/)/,'').try(
						:gsub,/_+/,'_')}"
				) ) 
			s2 = @template.submit_link_to(value,nil,options)
			s2 << s1
		end 

		def hour_select(method,options={},html_options={})
#			@template.hour_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				(1..12),
				{:include_blank => 'Hour'}.merge(options), html_options)
		end

		def minute_select(method,options={},html_options={})
#			@template.minute_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			minutes = (0..59).to_a.collect{|m|[sprintf("%02d",m),m]}
			@template.select(object_name, method,
				minutes,
				{:include_blank => 'Minute'}.merge(options), html_options)
		end

		def meridiem_select(method,options={},html_options={})
#			@template.meridiem_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				['AM','PM'], 
				{:include_blank => 'Meridiem'}.merge(options), html_options)
		end

		def sex_select(method,options={},html_options={})
#			@template.sex_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				[['-select-',''],['male','M'],['female','F'],["don't know",'DK']],
				options, html_options)
		end
		alias_method :gender_select, :sex_select

		def date_text_field(method, options = {})
#			@template.date_text_field(
#				@object_name, method, objectify_options(options))
			format = options.delete(:format) || '%m/%d/%Y'
			tmp_value = if options[:value].blank? #and !options[:object].nil?
#				object = options[:object]
				tmp = self.object.send("#{method}") ||
				      self.object.send("#{method}_before_type_cast")
			else
				options[:value]
			end
			begin
				options[:value] = tmp_value.to_date.try(:strftime,format)
			rescue NoMethodError, ArgumentError
				options[:value] = tmp_value
			end
			options.update(:class => [options[:class],'datepicker'].compact.join(' '))
			@template.text_field( object_name, method, options )
		end

	#	def y_n_dk_select(method,options={},html_options={})
	#		@template.y_n_dk_select(
	#			@object_name, method, 
	#				objectify_options(options),
	#				html_options)
	#	end
	#	alias_method :yndk_select, :y_n_dk_select


#	TODO add an equivalent field wrapper here.
#		this actually call the base field_wrapper and methods
#
#		def method_missing_with_wrapping(symb,*args, &block)
#			method_name = symb.to_s
#			if method_name =~ /^wrapped_(.+)$/
#				i = args.find_index{|i| i.is_a?(Hash) }
#				if i.nil?
#					args.push(objectify_options({}))
#				else
#					args[i] = objectify_options(args[i]) 	
#				end
##	NOTE this is NOT the method in this file.  It would be the method in the base.rb file
#				@template.send(method_name,@object_name,*args,&block)
##				send(method_name,@object_name,*args,&block)
#			else
#				method_missing_without_wrapping(symb,*args, &block)
#			end
#		end

		def method_missing_with_field_wrapping(symb,*args, &block)
			method_name = symb.to_s
			if method_name =~ /^wrapped_(.+)$/
				unwrapped_method_name = $1
#				object_name = args[0]
#				method      = args[1]
				method      = args[0]
				content = @template.field_wrapper(method,:class => unwrapped_method_name) do
					s = if respond_to?(unwrapped_method_name)
						options    = args.detect{|i| i.is_a?(Hash) }
						label_text = options.delete(:label_text) unless options.nil?
						if unwrapped_method_name == 'check_box'
							send("#{unwrapped_method_name}",*args,&block) <<
							self.label( method, label_text )
						else
							self.label( method, label_text ) <<
							send("#{unwrapped_method_name}",*args,&block)
						end
					else
						send("_#{method_name}",*args,&block)
					end
#					s << (( block_given? )? capture(&block) : '')
					s << (( block_given? )? @template.capture(&block) : '')
				end
#				( block_called_from_erb?(block) ) ? concat(content) : content
#				( @template.block_called_from_erb?(block) ) ? @template.concat(content) : content
				content
			else
				method_missing_without_field_wrapping(symb,*args, &block)
			end
		end

#		alias_method_chain( :method_missing, :wrapping
#			) unless respond_to?(:method_missing_without_wrapping)

protected

		def field_wrapper(method,options={},&block)
			classes = [method,options[:class]].compact.join(' ')
			s =  "<div class='#{classes} field_wrapper'>\n"
			s << yield 
			s << "\n</div><!-- class='#{classes}' -->"
		end

	end	#	module InstanceMethods

end
ActionView::Helpers::FormBuilder.send(:include, 
	CommonLib::ActionViewExtension::FormBuilder )


__END__

from base.rb

		def method_missing_with_wrapping(symb,*args, &block)
			method_name = symb.to_s
			if method_name =~ /^wrapped_(.+)$/
				unwrapped_method_name = $1
				object_name = args[0]
				method      = args[1]
				content = field_wrapper(method,:class => unwrapped_method_name) do
					s = if respond_to?(unwrapped_method_name)
						options    = args.detect{|i| i.is_a?(Hash) }
						label_text = options.delete(:label_text) unless options.nil?
						if unwrapped_method_name == 'check_box'
							send("#{unwrapped_method_name}",*args,&block) <<
							label( object_name, method, label_text )
						else
							label( object_name, method, label_text ) <<
							send("#{unwrapped_method_name}",*args,&block)
						end
					else
						send("_#{method_name}",*args,&block)
					end

					s << (( block_given? )? capture(&block) : '')
				end
				( block_called_from_erb?(block) ) ? concat(content) : content
			else
				method_missing_without_wrapping(symb,*args, &block)
			end
		end

