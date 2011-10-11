module CommonLib::ActiveSupportExtension::Attributes

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
		base.class_eval do 
			class << self
				alias_methods = {
					:require_unique_attributes  => :require_unique_attribute,
					:require_unique             => :require_unique_attribute,
					:require_attributes_not_nil => :require_attribute_not_nil,
					:require_not_nil            => :require_attribute_not_nil,
					:require_attributes         => :require_attribute,
					:require                    => :require_attribute,
					:not_require_attributes     => :not_require_attribute,
					:not_require                => :not_require_attribute,
					:require_attributes_length  => :require_attribute_length,
					:require_length             => :require_attribute_length,
					:protect_attributes         => :protect_attribute,
					:protect                    => :protect_attribute,
					:not_protect_attributes     => :not_protect_attribute,
					:not_protect                => :not_protect_attribute
				}
				alias_methods.each do |alias_name,method_name|
					alias_method( "assert_should_#{alias_name}", 
						"assert_should_#{method_name}" ) unless
							self.method_defined?("assert_should_#{alias_name}")
				end	#	alias_methods.each
			end	#	class << self
		end	#	base.class_eval
	end	# def self.included

	module ClassMethods

		def assert_should_require_unique_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || st_model_name
			
			attributes.each do |attr|
				attr = attr.to_s
				title = "#{brand}should require unique #{attr}"
				scope = options[:scope]
				unless scope.blank?
					title << " scope "
					title << (( scope.is_a?(Array) )?scope.join(','):scope.to_s)
				end
				test title do
					o = create_object
					assert_no_difference "#{model}.count" do
						attrs = { attr.to_sym => o.send(attr) }
						if( scope.is_a?(String) || scope.is_a?(Symbol) )
							attrs[scope.to_sym] = o.send(scope.to_sym)
						elsif scope.is_a?(Array)
							scope.each do |s|
								attrs[s.to_sym] = o.send(s.to_sym)
							end
						end 
						object = create_object(attrs)
						assert object.errors.on_attr_and_type(attr.to_sym, :taken)
					end
				end
			end
		end

		def assert_should_require_attribute_not_nil(*attributes)
			options = attributes.extract_options!
			model = options[:model] || st_model_name
			
			attributes.each do |attr|
				attr = attr.to_s
				test "#{brand}should require #{attr} not nil" do
					assert_no_difference "#{model}.count" do
						object = create_object(attr.to_sym => nil)
						assert object.errors.on(attr.to_sym)
					end
				end
			end
		end

		def assert_should_require_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || st_model_name
			
			attributes.each do |attr|
				attr = attr.to_s
				test "#{brand}should require #{attr}" do
					assert_no_difference "#{model}.count" do
						object = create_object(attr.to_sym => nil)
						assert object.errors.on_attr_and_type(attr.to_sym, :blank) ||
							object.errors.on_attr_and_type(attr.to_sym, :too_short)
					end
				end
			end
		end

		def assert_should_not_require_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || st_model_name
			
			attributes.each do |attr|
				attr = attr.to_s
				test "#{brand}should not require #{attr}" do
					assert_difference( "#{model}.count", 1 ) do
						object = create_object(attr.to_sym => nil)
						assert !object.errors.on(attr.to_sym)
						if attr =~ /^(.*)_id$/
							assert !object.errors.on($1.to_sym)
						end
					end
				end
			end
		end

		def assert_should_require_attribute_length(*attributes)
			options = attributes.extract_options!
			model = options[:model] || st_model_name

			if( ( options.keys & [:in,:within] ).length >= 1 )
				range = options[:in]||options[:within]
				options[:minimum] = range.min
				options[:maximum] = range.max
			end
			
			attributes.each do |attr|
				attr = attr.to_s
				if options.keys.include?(:is)
					length = options[:is]
					test "#{brand}should require exact length of #{length} for #{attr}" do
						assert_no_difference "#{model}.count" do
							value = 'x'*(length-1)
							object = create_object(attr.to_sym => value)
							assert_equal length-1, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert object.errors.on_attr_and_type(attr.to_sym, :wrong_length)
						end
						assert_no_difference "#{model}.count" do
							value = 'x'*(length+1)
							object = create_object(attr.to_sym => value)
							assert_equal length+1, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert object.errors.on_attr_and_type(attr.to_sym, :wrong_length)
						end
					end
				end

				if options.keys.include?(:minimum)
					min = options[:minimum]
					test "#{brand}should require min length of #{min} for #{attr}" do
#	because the model may have other requirements
#	just check to ensure that we don't get a :too_short error
#						assert_difference "#{model}.count" do
							value = 'x'*(min)
							object = create_object(attr.to_sym => value)
							assert_equal min, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert !object.errors.on_attr_and_type(attr.to_sym, :too_short)
#						end
						assert_no_difference "#{model}.count" do
							value = 'x'*(min-1)
							object = create_object(attr.to_sym => value)
							assert_equal min-1, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert object.errors.on_attr_and_type(attr.to_sym, :too_short)
						end
					end
				end

				if options.keys.include?(:maximum)
					max = options[:maximum]
					test "#{brand}should require max length of #{max} for #{attr}" do
#	because the model may have other requirements
#	just check to ensure that we don't get a :too_long error
#						assert_difference "#{model}.count" do
							value = 'x'*(max)
							object = create_object(attr.to_sym => value)
							assert_equal max, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert !object.errors.on_attr_and_type(attr.to_sym, :too_long)
#						end
						assert_no_difference "#{model}.count" do
							value = 'x'*(max+1)
							object = create_object(attr.to_sym => value)
							assert_equal max+1, object.send(attr.to_sym).length
							assert_equal object.send(attr.to_sym), value
							assert object.errors.on_attr_and_type(attr.to_sym, :too_long)
						end
					end
				end

			end
		end

		def assert_should_protect_attribute(*attributes)
			options = attributes.extract_options!
			model_name = options[:model] || st_model_name
			model = model_name.constantize
			
			attributes.each do |attr|
				attr = attr.to_s
				test "#{brand}should protect attribute #{attr}" do
					assert model.accessible_attributes||model.protected_attributes,
						"Both accessible and protected attributes are empty"
					assert !(model.accessible_attributes||[]).include?(attr),
						"#{attr} is included in accessible attributes"
					if !model.protected_attributes.nil?
						assert model.protected_attributes.include?(attr),
							"#{attr} is not included in protected attributes"
					end
				end
			end
		end

		def assert_should_not_protect_attribute(*attributes)
			options = attributes.extract_options!
			model_name = options[:model] || st_model_name
			model = model_name.constantize
			
			attributes.each do |attr|
				attr = attr.to_s
				test "#{brand}should not protect attribute #{attr}" do
					assert !(model.protected_attributes||[]).include?(attr),
						"#{attr} is included in protected attributes"
					if !model.accessible_attributes.nil?
						assert model.accessible_attributes.include?(attr),
							"#{attr} is not included in accessible attributes"
					end
				end
			end
		end

	end

end	# module CommonLib::ActiveSupportExtension::Attributes
ActiveSupport::TestCase.send(:include,
	CommonLib::ActiveSupportExtension::Attributes)
