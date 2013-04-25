module CommonLib::ActiveSupportExtension::Attributes

	def self.included(base)
		base.extend ClassMethods
		base.class_eval do 
			class << self
				alias_methods = {
					:not_require_unique_attributes => :not_require_unique_attribute,
					:not_require_unique            => :not_require_unique_attribute,
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

		def assert_should_not_require_unique_attribute(*attributes)
			options = attributes.extract_options!
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				title = "#{brand}should not require unique #{attr}"
				scope = options[:scope]
				unless scope.blank?
					title << " scope "
					title << (( scope.is_a?(Array) ) ? scope.join(',') : scope.to_s )
				end
				test title do
					o = create_object
					attrs = { attr.to_sym => o.send(attr) }
					if( scope.is_a?(String) || scope.is_a?(Symbol) )
						attrs[scope.to_sym] = o.send(scope.to_sym)
					elsif scope.is_a?(Array)
						scope.each do |s|
							attrs[s.to_sym] = o.send(s.to_sym)
						end
					end 
					object = create_object(attrs)
					assert !object.errors.matching?(attr,'has already been taken'),
						object.errors.full_messages.to_sentence
				end
			end
		end

		def assert_should_require_unique_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				title = "#{brand}should require unique #{attr}"
				scope = options[:scope]
				unless scope.blank?
					title << " scope "
					title << (( scope.is_a?(Array) ) ? scope.join(',') : scope.to_s)
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
						assert object.errors.matching?(attr,'has already been taken'),
							object.errors.full_messages.to_sentence
					end
				end
			end
		end

		def assert_should_require_attribute_not_nil(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				test "#{brand}should require #{attr} not nil" do
					object = model.constantize.new
					object.send("#{attr}=", nil)
					assert !object.valid?
					#		message could be a number of things ...
					# "is not included in the list","can't be blank"
					assert object.errors.include?(attr.to_sym),
						object.errors.full_messages.to_sentence
				end
			end
		end

		def assert_should_require_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				test "#{brand}should require #{attr}" do
					object = model.constantize.new
					object.send("#{attr}=", nil)
					assert !object.valid?
					assert object.errors.include?(attr.to_sym),
						object.errors.full_messages.to_sentence
					assert object.errors.matching?(attr,"can't be blank") ||
						object.errors.matching?(attr,'is too short'),
						object.errors.full_messages.to_sentence
				end
			end
		end

		def assert_should_not_require_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				test "#{brand}should not require #{attr}" do
					object = model.constantize.new
					object.send("#{attr}=", nil)
					#	don't know if it will be true or false, but must be called
					object.valid?	
					assert !object.errors.include?(attr.to_sym),
						object.errors.full_messages.to_sentence
					if attr =~ /^(.*)_id$/
						assert !object.errors.include?($1.to_sym),
							object.errors.full_messages.to_sentence
					end
				end
			end
		end

		def assert_should_require_attribute_length(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test

			if( ( options.keys & [:in,:within] ).length >= 1 )
				range = options[:in]||options[:within]
				options[:minimum] = range.min
				options[:maximum] = range.max
			end
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				if options.keys.include?(:is)
					length = options[:is]
					test "#{brand}should require exact length of #{length} for #{attr}" do
						value = 'x'*(length-1)
						object = model.constantize.new
						object.send("#{attr}=", value)
						assert !object.valid?
						assert_equal length-1, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert object.errors.include?(attr.to_sym),
							object.errors.full_messages.to_sentence
						assert object.errors.matching?(attr,'is the wrong length'),
							object.errors.full_messages.to_sentence

						value = 'x'*(length+1)
						object = model.constantize.new
						object.send("#{attr}=", value)
						assert !object.valid?
						assert_equal length+1, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert object.errors.include?(attr.to_sym),
							object.errors.full_messages.to_sentence
						assert object.errors.matching?(attr,'is the wrong length'),
							object.errors.full_messages.to_sentence
					end
				end

				if options.keys.include?(:minimum)
					min = options[:minimum]
					test "#{brand}should require min length of #{min} for #{attr}" do
						value = 'x'*(min)
						object = model.constantize.new
						object.send("#{attr}=", value)
						#	don't know if really valid
						object.valid?
						assert_equal min, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert !object.errors.matching?(attr,'is too short'),
							object.errors.full_messages.to_sentence

						value = 'x'*(min-1)
						object = model.constantize.new
						object.send("#{attr}=", value)
						assert !object.valid?
						assert_equal min-1, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert object.errors.include?(attr.to_sym),
							object.errors.full_messages.to_sentence
						assert object.errors.matching?(attr,'is too short'),
							object.errors.full_messages.to_sentence
					end
				end

				if options.keys.include?(:maximum)
					max = options[:maximum]
					test "#{brand}should require max length of #{max} for #{attr}" do
						value = 'x'*(max)
						object = model.constantize.new
						object.send("#{attr}=", value)
						#	don't know if really valid
						object.valid?
						assert_equal max, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert !object.errors.matching?(attr,'is too long'),
							object.errors.full_messages.to_sentence

						value = 'x'*(max+1)
						object = model.constantize.new
						object.send("#{attr}=", value)
						assert !object.valid?
						assert_equal max+1, object.send(attr.to_sym).length
						assert_equal object.send(attr.to_sym), value
						assert object.errors.include?(attr.to_sym),
							object.errors.full_messages.to_sentence
						assert object.errors.matching?(attr,'is too long'),
							object.errors.full_messages.to_sentence
					end
				end

			end
		end

		def assert_should_protect_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				test "#{brand}should protect attribute #{attr}" do
					assert model.constantize.accessible_attributes||model.constantize.protected_attributes,
						"Both accessible and protected attributes are empty"
					assert !(model.constantize.accessible_attributes||[]).include?(attr),
						"#{attr} is included in accessible attributes"
					if !model.constantize.protected_attributes.nil?
						assert model.constantize.protected_attributes.include?(attr),
							"#{attr} is not included in protected attributes"
					end
				end
			end
		end

#	>> Abstract.accessible_attributes
#	=> #<ActiveModel::MassAssignmentSecurity::WhiteList: {}>

#	>> Abstract.protected_attributes
#	=> #<ActiveModel::MassAssignmentSecurity::BlackList: {"study_subject", "entry_2_by_uid", "entry_1_by_uid", "id", "type", "study_subject_id", "merged_by_uid"}>

		def assert_should_not_protect_attribute(*attributes)
			options = attributes.extract_options!
			model = options[:model] || model_name_without_test
			
			attributes.flatten.each do |attr|
				attr = attr.to_s
				test "#{brand}should not protect attribute #{attr}" do
					assert !model.constantize.protected_attributes.include?(attr),
						"#{attr} is included in protected attributes"

#	Rails 3 change
#	apparently no longer always true
#					if !model.accessible_attributes.nil?
#						assert model.accessible_attributes.include?(attr),
#							"#{attr} is not included in accessible attributes"
#					end

				end
			end
		end

	end

end	# module ActiveSupportExtension::Attributes
ActiveSupport::TestCase.send(:include, CommonLib::ActiveSupportExtension::Attributes)
