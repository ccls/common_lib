module CommonLib::ActionViewExtension::Base

	def mdy(date)
		( date.nil? ) ? '&nbsp;' : date.strftime("%m/%d/%Y")
	end

	def time_mdy(time)
		( time.nil? ) ? '&nbsp;' : time.strftime("%I:%M %p %m/%d/%Y")
	end

#	def y_n_dk(value)
#		case value
#			when 1   then 'Yes'
#			when 2   then 'No'
#			when 999 then "Don't Know"
#			else '&nbsp;'
#		end
#	end
#	alias_method :yndk, :y_n_dk

	def field_wrapper(method,options={},&block)
		classes = [method,options[:class]].compact.join(' ')
		s =  "<div class='#{classes} field_wrapper'>\n"
		s << yield 
		s << "\n</div><!-- class='#{classes}' -->"
	end

	#	This is NOT a form field
	def _wrapped_spans(object_name,method,options={})
		s =  "<span class='label'>#{options[:label_text]||method}</span>\n"
		value = if options[:value]
			options[:value]
		else
			object = instance_variable_get("@#{object_name}")
			value = object.send(method)
			value = (value.to_s.blank?)?'&nbsp;':value
		end
		s << "<span class='value'>#{value}</span>"
	end

#	def _wrapped_y_n_dk_spans(object_name,method,options={})
#		object = instance_variable_get("@#{object_name}")
#		_wrapped_spans(object_name,method,options.update(
#			:value => y_n_dk(object.send(method)) ) )
#	end
#	alias_method :_wrapped_yndk_spans, :_wrapped_y_n_dk_spans

	def _wrapped_date_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => mdy(object.send(method)) ) )
	end

	def sex_select(object_name, method, 
			options={}, html_options={})
		select(object_name, method,
			[['-select-',''],['male','M'],['female','F'],["don't know",'DK']],
			options, html_options)
	end
	alias_method :gender_select, :sex_select

	def date_text_field(object_name,method,options={})
		format = options.delete(:format) || '%m/%d/%Y'
		tmp_value = if options[:value].blank? #and !options[:object].nil?
			object = options[:object]
			tmp = object.send("#{method}") ||
			      object.send("#{method}_before_type_cast")
		else
			options[:value]
		end
		begin
			options[:value] = tmp_value.to_date.try(:strftime,format)
		rescue NoMethodError, ArgumentError
			options[:value] = tmp_value
		end
		options.update(:class => [options[:class],'datepicker'].compact.join(' '))
		text_field( object_name, method, options )
	end

	#	This is NOT a form field
	def _wrapped_yes_or_no_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		s =  "<span class='label'>#{options[:label_text]||method}</span>\n"
		value = (object.send("#{method}?"))?'Yes':'No'
		s << "<span class='value'>#{value}</span>"
	end

#	def y_n_dk_select(object_name, method, 
#			options={}, html_options={})
#		select(object_name, method,
#			[['Yes',1],['No',2],["Don't Know",999]],
#			{:include_blank => true}.merge(options), html_options)
#	end
#	alias_method :yndk_select, :y_n_dk_select

	def hour_select(object_name, method, 
			options={}, html_options={})
		select(object_name, method,
			(1..12),
			{:include_blank => 'Hour'}.merge(options), html_options)
	end

	def minute_select(object_name, method, 
			options={}, html_options={})
		minutes = (0..59).to_a.collect{|m|[sprintf("%02d",m),m]}
		select(object_name, method,
			minutes,
			{:include_blank => 'Minute'}.merge(options), html_options)
	end

	def meridiem_select(object_name, method, 
			options={}, html_options={})
		select(object_name, method,
			['AM','PM'], 
			{:include_blank => 'Meridiem'}.merge(options), html_options)
	end

	def self.included(base)
		base.class_eval do
			alias_method_chain( :method_missing, :wrapping 
				) unless base.respond_to?(:method_missing_without_wrapping)
		end
	end

	def method_missing_with_wrapping(symb,*args, &block)
		method_name = symb.to_s
		if method_name =~ /^wrapped_(.+)$/
			unwrapped_method_name = $1
#
#	It'd be nice to be able to genericize all of the
#	wrapped_* methods since they are all basically
#	the same.
#		Strip of the "wrapped_"
#		Label
#		Call "unwrapped" method
#

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
#				send("_#{method_name}",*args) << 
#					(( block_given? )? capture(&block) : '')
			end
			if block_called_from_erb?(block)
				concat(content)
			else
				content
			end
		else
			method_missing_without_wrapping(symb,*args, &block)
		end
	end


	#	Just add the classes 'submit' and 'button'
	#	for styling and function
	def submit_link_to(*args,&block)
		html_options = if block_given?
			args[1] ||= {}
		else
			args[2] ||= {}
		end
		html_options.delete(:value)   #	possible key meant for submit button
		html_options.delete('value')  #	possible key meant for submit button
		( html_options[:class] ||= '' ) << ' submit button'
		link_to( *args, &block )
	end


	def form_link_to( title, url, options={}, &block )
#			"action='#{url}' " <<
		extra_tags = extra_tags_for_form(options)
		s =  "\n" <<
			"<form " <<
			"class='#{options.delete(:class)||'form_link_to'}' " <<
			"action='#{url_for(url)}' " <<
			"method='#{options.delete('method')}'>\n" <<
			extra_tags << "\n"
		s << (( block_given? )? capture(&block) : '')
		s << submit_tag(title, :name => nil ) << "\n" <<
			"</form>\n"
		if block_called_from_erb?(block)
			concat(s)
		else
			s
		end
	end

	def destroy_link_to( title, url, options={}, &block )
		s = form_link_to( title, url, options.merge(
			'method' => 'delete',
			:class => 'destroy_link_to'
		),&block )
	end

	def aws_image_tag(image,options={})
		#	in console @controller is nil
		protocol = @controller.try(:request).try(:protocol) || 'http://'
		host = 's3.amazonaws.com/'
		bucket = ( defined?(RAILS_APP_NAME) && RAILS_APP_NAME ) || 'ccls'
		src = "#{protocol}#{host}#{bucket}/images/#{image}"
		alt = options.delete(:alt) || options.delete('alt') || image
		tag('img',options.merge({:src => src, :alt => alt}))
	end

	#	This style somehow for some reason actually submits the request TWICE?
	#	In many cases, this is no big deal, but when using it to send
	#	emails or something, the controller/action is called twice
	#	resulting in 2 emails (if that's what your action does)
	#	I'd really like to understand why.
	def button_link_to( title, url, options={} )
		classes = ['link']
		classes << options[:class]
		s =  "<a href='#{url_for(url)}' style='text-decoration:none;'>"
		s << "<button type='button'>"
		s << title
		s << "</button></a>\n"
	end

	#	This creates a button that looks like a submit button
	#	but is just a javascript controlled link.
	#	I don't like it.
	def old_button_link_to( title, url, options={} )
#		id = "id='#{options[:id]}'" unless options[:id].blank?
#		klass = if options[:class].blank?
#			"class='link'"
#		else
#			"class='#{options[:class]}'"
#		end
#		s =  "<button #{id} #{klass} type='button'>"
		classes = ['link']
		classes << options[:class]
		s =  "<button class='#{classes.flatten.join(' ')}' type='button'>"
		s << "<span class='href' style='display:none;'>"
		s << url_for(url)
		s << "</span>"
		s << title
		s << "</button>"
		s
	end

	def flasher
		s = ''
		flash.each do |key, msg|
			s << content_tag( :p, msg, :id => key, :class => 'flash' )
			s << "\n"
		end
		s << "<noscript><p id='noscript' class='flash'>\n"
		s << "Javascript is required for this site to be fully functional.\n"
		s << "</p></noscript>\n"
	end

	#	Created to stop multiple entries of same stylesheet
	def stylesheets(*args)
		@stylesheets ||= []
		args.each do |stylesheet|
			unless @stylesheets.include?(stylesheet.to_s)
				@stylesheets.push(stylesheet.to_s)
				content_for(:head,stylesheet_link_tag(stylesheet.to_s))
			end
		end
	end

	def javascripts(*args)
		@javascripts ||= []
		args.each do |javascript|
			unless @javascripts.include?(javascript.to_s)
				@javascripts.push(javascript.to_s)
				content_for(:head,javascript_include_tag(javascript).to_s)
			end
		end
	end

end	#	module CommonLib::ActionViewExtension::Base
ActionView::Base.send(:include, CommonLib::ActionViewExtension::Base )
