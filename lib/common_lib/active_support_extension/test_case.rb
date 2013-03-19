module CommonLib::ActiveSupportExtension::TestCase

	def self.included(base)
		# basically to include the model_name method to the CLASS
		base.extend ActiveModel::Naming
		base.extend(ClassMethods)
	end

	module ClassMethods
#
#	this used to be called st_model_name, which I think
#	was short for simply_testable_model_name. Of course,
#	I left no description
#
		def model_name_without_test
			self.name.demodulize.sub(/Test$/,'')
		end

		def assert_should_act_as_list(*args)
			options = args.extract_options!
			scope = options[:scope]

			test "#{brand}should act as list" do
				object = create_object
				first_position = object.position
				assert first_position > 0
				attrs = {}
				Array(scope).each do |attr|
					attrs[attr.to_sym] = object.send(attr)
				end if scope
				object = create_object(attrs)
				assert_equal ( first_position + 1 ), object.position
				object = create_object(attrs)
				assert_equal ( first_position + 2 ), object.position
			end

		end

#
#
#	What? No assert_requires_absence method???
#	Its usually conditional so would be pretty pointless
#

		def assert_requires_past_date(*attr_names)
			options = { :allow_today => true }
			options.update(attr_names.extract_options!)
			model = options[:model] || model_name_without_test

			attr_names.each do |attr_name|
				if options[:allow_today]
					test "#{brand}should allow #{attr_name} to be today" do
						object = model.constantize.new
						object.send("#{attr_name}=", Date.today)
						object.valid?		#	could be, but probably isn't
						assert !object.errors.matching?(attr_name,
							'is in the future and must be in the past'),
							"Expected #{attr_name}:is NOT not a past date, but only got " <<
								object.errors.full_messages.to_sentence
					end
				else
					test "#{brand}should NOT allow #{attr_name} to be today" do
						object = model.constantize.new
						object.send("#{attr_name}=", Date.today)
						assert !object.valid?
						assert object.errors.matching?(attr_name,
							'is in the future and must be in the past'),
							"Expected #{attr_name}:is not a past date, but only got " <<
								object.errors.full_messages.to_sentence
					end
				end
				test "#{brand}should require #{attr_name} be in the past" do
					object = model.constantize.new
					object.send("#{attr_name}=", Date.yesterday)
					object.valid?		#	could be, but probably isn't
					assert !object.errors.matching?(attr_name,
						'is in the future and must be in the past'),
						"Expected #{attr_name}:is NOT not a past date, but only got " <<
							object.errors.full_messages.to_sentence

					object = model.constantize.new
					object.send("#{attr_name}=", Date.tomorrow)
					assert !object.valid?
					assert object.errors.matching?(attr_name,
						'is in the future and must be in the past'),
						"Expected #{attr_name}:is not a past date, but only got " <<
							object.errors.full_messages.to_sentence
				end
			end
		end
	

		def assert_requires_complete_date(*attr_names)
			options = attr_names.extract_options!
			model = options[:model] || model_name_without_test

			attr_names.each do |attr_name|
				test "#{brand}should require a complete date for #{attr_name}" do
					object = model.constantize.new
					object.send("#{attr_name}=", "Sept 11, 2001")
					object.valid?		#	could be, but probably isn't
					assert !object.errors.matching?(attr_name,'is not a complete date'),
						"Expected #{attr_name}:is NOT not a complete date, but only got " <<
							object.errors.full_messages.to_sentence

					object = model.constantize.new
					object.send("#{attr_name}=", "Sept 2001")
					assert !object.valid?
					assert object.errors.matching?(attr_name,'is not a complete date'),
						"Expected #{attr_name}:is not a complete date, but only got " <<
							object.errors.full_messages.to_sentence

					object = model.constantize.new
					object.send("#{attr_name}=", "9/2001")
					assert !object.valid?
					assert object.errors.matching?(attr_name,'is not a complete date')
						"Expected #{attr_name}:is not a complete date, but only got " <<
							object.errors.full_messages.to_sentence
				end
			end
		end

	end


	at_exit { 
		puts Dir.pwd() 
		puts Time.now
	}

	#	basically a copy of assert_difference, but
	#	without any explicit comparison as it is 
	#	simply stating that something will change
	#	(designed for updated_at)
	def assert_changes(expression, message = nil, &block)
		b = block.send(:binding)
		exps = Array.wrap(expression)
		before = exps.map { |e| eval(e, b) }
		yield
		exps.each_with_index do |e, i|
			error = "#{e.inspect} didn't change"
			error = "#{message}.\n#{error}" if message
			assert_not_equal(before[i], eval(e, b), error)
		end
	end

	#	Just a negation of assert_changes
	def deny_changes(expression, message = nil, &block)
		b = block.send(:binding)
		exps = Array.wrap(expression)
		before = exps.map { |e| eval(e, b) }
		yield
		exps.each_with_index do |e, i|
			error = "#{e.inspect} changed"
			error = "#{message}.\n#{error}" if message
			assert_equal(before[i], eval(e, b), error)
		end
	end

	def turn_off_paperclip_logging
		#	Is there I way to silence the paperclip output?  Yes...
		Paperclip.options[:log] = false
		#	Is there I way to capture the paperclip output for comparison?  Don't know.
	end

end	#	ActiveSupportExtension::TestCase
ActiveSupport::TestCase.send(:include, CommonLib::ActiveSupportExtension::TestCase)
__END__
