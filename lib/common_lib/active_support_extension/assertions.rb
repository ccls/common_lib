module CommonLib::ActiveSupportExtension::Assertions

	def self.included(base)
		base.extend(ClassMethods)
	end

#	def assert_subject_is_eligible(study_subject)
#		hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
#		assert_not_nil hxe
#		assert_nil     hxe.ineligible_reason_id
#		assert_equal   hxe.is_eligible, YNDK[:yes]
#	end
#	alias_method :assert_study_subject_is_eligible, :assert_subject_is_eligible
#
#	def assert_subject_is_not_eligible(study_subject)
#		hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
#		assert_not_nil hxe
#		assert_not_nil hxe.ineligible_reason_id
#		assert_equal   hxe.is_eligible, YNDK[:no]
#	end
#	alias_method :assert_study_subject_is_not_eligible, :assert_subject_is_not_eligible

	def assert_blank obj, msg = nil
		msg ||= "Expected '#{obj}' to be blank"
		assert obj.blank?, msg
	end

	module ClassMethods

		def assert_should_create_default_object(*args)
			options = {}
			options.update(args.extract_options!)
			model = options[:model] || model_name_without_test

			test "should create default #{model.underscore}" do
				assert_difference( "#{model}.count", 1 ) do
					object = create_object
					assert !object.new_record?, 
						"#{object.errors.full_messages.to_sentence}"
				end
			end
		end

		def assert_should_behave_like_a_hash(*args)
			options = {
				:key => :key,
				:value => :description
			}
			options.update(args.extract_options!)
			model = options[:model] || model_name_without_test

			assert_should_require_attribute( options[:key], options[:value] )
			assert_should_require_unique_attribute( options[:key], options[:value] )
			assert_should_require_attribute_length( options[:key], options[:value],
				:maximum => 250 )

			test "should find by key with ['string']" do
				object = create_object
				assert object.is_a?(model.constantize)
				found = (model.constantize)[object.key.to_s]
				assert found.is_a?(model.constantize)
				assert_equal object, found
			end

			test "should find by key with [:symbol]" do
				object = create_object
				assert object.is_a?(model.constantize)
				found = (model.constantize)[object.key.to_sym]
				assert found.is_a?(model.constantize)
				assert_equal object, found
			end

		end	#	def assert_should_behave_like_a_hash(*args)

		def assert_should_accept_only_good_values(*attributes)
			options = {
				:good_values => [],
				:bad_values  => []
			}
			options.update(attributes.extract_options!)
			model = options[:model] || model_name_without_test

			attributes.flatten.each do |field|

				[options[:bad_values]].flatten.each do |value|

#	could be a naming problem if both nil and blank are passed

					test "should NOT allow #{value||'nil'} for #{field}" do
						object = model.constantize.new(field => value)
						assert_equal object.send(field), value
						object.valid?
						assert object.errors.matching?(field,'is not included in the list')
					end

				end

				[options[:good_values]].flatten.each do |value|
		
#	could be a naming problem if both nil and blank are passed

					test "should allow #{value||'nil'} for #{field}" do
						object = model.constantize.new(field => value)
						assert_equal object.send(field), value
						object.valid?
						assert !object.errors.include?(field)
					end

				end
		
			end	#	attributes.flatten.each do |field|

		end	#	def assert_should_accept_only_good_values(*attributes)

	end	#	module ClassMethods

end	#	module ActiveSupportExtension::Assertions
ActiveSupport::TestCase.send(:include,CommonLib::ActiveSupportExtension::Assertions)
