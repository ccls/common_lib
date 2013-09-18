module CommonLib::ActionViewExtension::Base

	def self.included(base)
		base.class_eval do
			#	This NEEDS to be HERE or gets stuck at method_missing_without_wrapping call????
			alias_method_chain( :method_missing, :wrapping )
		end
	end

	# Just a simple method to wrap the passed text in a span
	# with class='required'
	def required(text)
		"<span class='required'>#{text}</span>".html_safe
	end
	alias_method :req, :required

	def nbsp
		"&nbsp;".html_safe
	end

	def mdy(date)
		( date.blank? or !date.respond_to?(:strftime) ) ? nbsp : date.strftime("%m/%d/%Y")
	end

	#	For use in CSV output as don't want the &nbsp;
	def mdy_or_nil(date)
		( date.blank? or !date.respond_to?(:strftime) ) ? nil : date.strftime("%m/%d/%Y")
	end

	def mdyhm(datetime)
		( datetime.blank? or !datetime.respond_to?(:strftime) ) ? nbsp : 
				datetime.strftime("%m/%d/%Y %H:%M (%Z)")
	end

	#	For use in CSV output as don't want the &nbsp;
	def mdyhm_or_nil(datetime)
		( datetime.blank? or !datetime.respond_to?(:strftime) ) ? nil : 
				datetime.strftime("%m/%d/%Y %H:%M (%Z)")
	end
	
	def time_mdy(time)
		( time.blank? or !time.respond_to?(:strftime) ) ? nbsp : 
				time.strftime("%I:%M %p %m/%d/%Y")
	end

	def field_wrapper(method,options={},&block)
		classes = [method,options[:class]].compact.join(' ')
		s =  "<div class='#{classes} field_wrapper'>\n"
		s << yield 
		s << "\n</div><!-- class='#{classes}' -->"
		s.html_safe
	end

# t is RedCloth.textualize NOT I18n.translate

	#	This is NOT a form field
	def _wrapped_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
#		s =  "<span class='label'>#{options[:label_text]||method}</span>\n"

#	could also "object.class.human_attribute_name method" ?

#		s =  "<span class='label'>#{options[:label_text]||I18n.translate(
#			"#{object.class.to_s.underscore}.#{method}",
#			:scope => "activerecord.attributes",
#			:default => method.to_s)}</span>\n"	#	if method is a symbol, tries to translate it too.

		s =  "<span class='label'>#{options[:label_text] ||
			( I18n.translate("#{object.class.to_s.underscore}.#{method}",
				:scope => "activerecord.attributes", :raise => true ) rescue false ) ||
			method.to_s.humanize }</span>\n"	#	if method is a symbol, tries to translate it too.

		#	titleize - capitalizes all words
		#	humanize - capitalizes only the first word ( same as other rails helpers )

		value = if options[:value]
			options[:value]
		else
#	moved to top
#			object = instance_variable_get("@#{object_name}")
			value = object.send(method)
			value = (value.to_s.blank?)?'&nbsp;':value
		end
		s << "<span class='value'>#{value}</span>"
		s << (( options.has_key?(:post_text) ) ? "<span class='post_text'>#{options[:post_text]}</span>" : "")
		s.html_safe
	end

	def _wrapped_date_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => mdy(object.send(method)) ) )
	end

	def _wrapped_datetime_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => mdyhm(object.send(method)) ) )
	end

	#	This is NOT a form field
	def _wrapped_yes_or_no_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (object.send("#{method}?"))?'Yes':'No') )
#		s =  "<span class='label'>#{options[:label_text]||method}</span>\n"
#		value = (object.send("#{method}?"))?'Yes':'No'
#		s << "<span class='value'>#{value}</span>"
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
#			if block_called_from_erb?(block)
#				concat(content)
#			else
				content
#			end
		else
			method_missing_without_wrapping(symb,*args, &block)
		end
	end

	def form_link_to( title, url, options={}, &block )
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
		s.html_safe
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
#		bucket = ( defined?(RAILS_APP_NAME) && RAILS_APP_NAME ) || 'ccls'
		bucket = ( defined?(RAILS_APP_NAME) && RAILS_APP_NAME ) || 
			Rails.application.class.parent.to_s.downcase || 'ccls'
		src = "#{protocol}#{host}#{bucket}/images/#{image}"
		alt = options.delete(:alt) || options.delete('alt') || image
		tag('img',options.merge({:src => src, :alt => alt}))
	end

	def flasher
		s = ''
		flash.each do |key, msg|
			s << content_tag( :p, msg, :id => key, :class => "flash #{key}" )
			s << "\n"
		end
		s << "<noscript><p id='noscript' class='flash'>\n"
		s << "Javascript is required for this site to be fully functional.\n"
		s << "</p></noscript>\n"
		s.html_safe
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

	def yndk(value=nil)
		(YNDK[value]||'&nbsp;').html_safe
	end

	def ynodk(value=nil)
		(YNODK[value]||'&nbsp;').html_safe
	end

	def ynrdk(value=nil)
		(YNRDK[value]||'&nbsp;').html_safe
	end

	def ynordk(value=nil)
		(YNORDK[value]||'&nbsp;').html_safe
	end

	def padk(value=nil)
		(PADK[value]||'&nbsp;').html_safe
	end

	def adna(value=nil)
		(ADNA[value]||'&nbsp;').html_safe
	end

	def pos_neg(value=nil)
		(POSNEG[value]||'&nbsp;').html_safe
	end
	alias_method :posneg, :pos_neg

	def _wrapped_yndk_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (YNDK[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_ynodk_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (YNODK[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_ynrdk_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (YNRDK[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_ynordk_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (YNORDK[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_padk_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (PADK[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_adna_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (ADNA[object.send(method)]||'&nbsp;') ) )
	end

	def _wrapped_pos_neg_spans(object_name,method,options={})
		object = instance_variable_get("@#{object_name}")
		_wrapped_spans(object_name,method,options.update(
			:value => (POSNEG[object.send(method)]||'&nbsp;') ) )
	end

end	#	module CommonLib::ActionViewExtension::Base
ActionView::Base.send(:include, 
	CommonLib::ActionViewExtension::Base )
