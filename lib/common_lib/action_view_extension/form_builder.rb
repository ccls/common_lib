
#	Would prefer to do this nicer

ActionView::Helpers::FormBuilder.class_eval do

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
		@template.hour_select(
			@object_name, method, 
				objectify_options(options),
				html_options)
	end

	def minute_select(method,options={},html_options={})
		@template.minute_select(
			@object_name, method, 
				objectify_options(options),
				html_options)
	end

	def meridiem_select(method,options={},html_options={})
		@template.meridiem_select(
			@object_name, method, 
				objectify_options(options),
				html_options)
	end

	def sex_select(method,options={},html_options={})
		@template.sex_select(
			@object_name, method, 
				objectify_options(options),
				html_options)
	end
	alias_method :gender_select, :sex_select

	def date_text_field(method, options = {})
		@template.date_text_field(
			@object_name, method, objectify_options(options))
	end

	def y_n_dk_select(method,options={},html_options={})
		@template.y_n_dk_select(
			@object_name, method, 
				objectify_options(options),
				html_options)
	end
	alias_method :yndk_select, :y_n_dk_select

	def method_missing_with_wrapping(symb,*args, &block)
		method_name = symb.to_s
		if method_name =~ /^wrapped_(.+)$/
			i = args.find_index{|i| i.is_a?(Hash) }
			if i.nil?
				args.push(objectify_options({}))
			else
				args[i] = objectify_options(args[i]) 	
			end
			@template.send(method_name,@object_name,*args,&block)
		else
			method_missing_without_wrapping(symb,*args, &block)
		end
	end

	alias_method_chain( :method_missing, :wrapping
		) unless respond_to?(:method_missing_without_wrapping)

end
