module CommonLib::ActionViewExtension::FormBuilder

	def error_messages
		if self.object.errors.count > 0
			s  = '<div id="errorExplanation" class="errorExplanation">'
			s << "<h2>#{self.object.errors.count} #{"error".pluralize(self.object.errors.count)} prohibited this #{self.object.class} from being saved:</h2>"
			s << '<p>There were problems with the following fields:</p>'
			s << '<ul>'
			self.object.errors.full_messages.each do |msg|
				s << "<li>#{msg}</li>"
			end
			s << '</ul></div>'
			s.html_safe
		end
	end

	def hour_select(method,options={},html_options={})
		@template.select(object_name, method,
			(1..12),
			{:include_blank => 'Hour'}.merge(options), html_options)
	end

	def minute_select(method,options={},html_options={})
		minutes = (0..59).to_a.collect{|m|[sprintf("%02d",m),m]}
		@template.select(object_name, method,
			minutes,
			{:include_blank => 'Minute'}.merge(options), html_options)
	end

	def meridiem_select(method,options={},html_options={})
		@template.select(object_name, method,
			['AM','PM'], 
			{:include_blank => 'Meridiem'}.merge(options), html_options)
	end

	def sex_select(method,options={},html_options={})
		@template.select(object_name, method,
			[['-select-',''],['male','M'],['female','F'],["don't know",'DK']],
			options, html_options)
	end
	alias_method :gender_select, :sex_select

	def date_text_field(method, options = {})
		format = options.delete(:format) || '%m/%d/%Y'
		tmp_value = if options[:value].blank? #and !options[:object].nil?
#			object = options[:object]
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

	def datetime_text_field(method, options = {})
		format = options.delete(:format) || '%m/%d/%Y %H:%M'
		tmp_value = if options[:value].blank?
			tmp = self.object.send("#{method}") ||
			      self.object.send("#{method}_before_type_cast")
		else
			options[:value]
		end
		begin
			options[:value] = tmp_value.to_datetime.try(:strftime,format)
		rescue NoMethodError, ArgumentError
			options[:value] = tmp_value
		end
		options.update(:class => [options[:class],'datetimepicker'].compact.join(' '))
		@template.text_field( object_name, method, options )
	end

	def yndk_select(method,options={},html_options={})
		@template.select(object_name, method, YNDK.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def ynrdk_select(method,options={},html_options={})
		@template.select(object_name, method, YNRDK.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def ynodk_select(method,options={},html_options={})
		@template.select(object_name, method, YNODK.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def ynordk_select(method,options={},html_options={})
		@template.select(object_name, method, YNORDK.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def padk_select(method,options={},html_options={})
		@template.select(object_name, method, PADK.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def adna_select(method,options={},html_options={})
		@template.select(object_name, method, ADNA.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def pos_neg_select(method, options={}, html_options={})
		@template.select(object_name, method, POSNEG.selector_options,
			{:include_blank => true}.merge(objectify_options(options)), html_options)
	end

	def wrapped_check_box(*args,&block)
		method      = args[0]
		content = @template.field_wrapper(method,:class => 'check_box') do
			options    = args.detect{|i| i.is_a?(Hash) }
			label_text = options.delete(:label_text) unless options.nil?
			post_text  = options.delete(:post_text) unless options.nil?
#	INVERTED ORDER SO NOT INCLUDED BELOW
			s  = check_box(*args,&block) <<
				self.label( method, label_text, class: 'label' )
			s << (( block_given? )? @template.capture(&block) : '')
			s << (( post_text.blank? ) ? '' : "<span>#{post_text}</span>".html_safe )
		end
		content.html_safe
	end

#	special
#		def wrapped_check_box(*args,&block)

#
#	This isn't pretty, but does appear to work.
#	Dynamically defined using a class_eval rather than
#	define_method. And no method_missing.
#
#	Actually, now that we're using ruby 1.9, can't I use
#	define_method with a block?
#
#	Add "field_error" class if errors.include?(method)
#
	%w( adna_select collection_select country_select 
			datetime_select date_text_field datetime_text_field 
			file_field password_field
			hour_select minute_select meridiem_select gender_select
			grouped_collection_select padk_select
			pos_neg_select select sex_select text_area
			text_field yndk_select ynodk_select ynrdk_select ynordk_select
		).each do |unwrapped_method_name|
	define_method "wrapped_#{unwrapped_method_name}" do |*args,&block|
#class_eval %Q"
#	def wrapped_#{unwrapped_method_name}(*args,&block)
		method      = args[0]
#		content = @template.field_wrapper(method,:class => '#{unwrapped_method_name}') do
		content = @template.field_wrapper(method,:class => unwrapped_method_name) do
			options    = args.detect{|i| i.is_a?(Hash) }
			label_text = options.delete(:label_text) unless options.nil?
			post_text  = options.delete(:post_text) unless options.nil?
			#	removing these from the options hash will stop them from being 
			#	passed on to the unwrapped_method

#			s  = self.label( method, label_text ) <<
#				#{unwrapped_method_name}(*args)
##				#{unwrapped_method_name}(*args,&block)
##	why pass the block along? usually a good idea, but these methods don't use it. (at least I don't see any)
##	if they did, then why capture it again too?
#			s << (( block_given? )? @template.capture(&block) : '')
#			s << (( post_text.blank? ) ? '' : \"<span>\#{post_text}</span>\".html_safe )

#	I would prefer to do this the newer way, but
#	when a wrapped method has a block with a wrapped method
#	it ends up being rendered a couple times ??

			s  = self.label( method, label_text, class: 'label'  ) 
			s << send(unwrapped_method_name,*args,&block)

#			s << (( block )? block.call : '')	
#			s << (( block_given? )? @template.capture(&block) : '')
#	the new way won't work with block_given?, but template.capture still does.
			s << (( block )? @template.capture(&block) : '')
#if block	#block_given? 
#	puts "BLOCK GIVEN"
##puts @template.concat(&block)
#puts @template.capture(&block)
#else
#	puts "NO BLOCK GIVEN"
#end
			s << (( post_text.blank? ) ? '' : "<span>#{post_text}</span>".html_safe )


		end
		content.html_safe
	end
#"
end

end
ActionView::Helpers::FormBuilder.send(:include, 
	CommonLib::ActionViewExtension::FormBuilder )
