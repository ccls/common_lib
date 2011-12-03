module CommonLib::ActiveSupportExtension::TestCase

	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.alias_method_chain :method_missing, :create_object

#	I can't seem to find out how to confirm that 
#	method_missing_without_create_object
#	doesn't already exist! WTF
#	We don't want to alias it if we already have.
#	tried viewing methods, instance_methods, etc.
#	seems to only work when "inherited" and since 
#	some thing are inherited from subclasses it
#	might get a bit hairy.  No problems now, just
#	trying to avoid them in the future.

		base.class_eval do
#alias_method(:method_missing_without_create_object,:method_missing)
#alias_method(:method_missing,:method_missing_with_create_object)
#			class << self
#				alias_method_chain :method_missing, :create_object #unless
#					respond_to?(:method_missing_without_create_object)
#			end
			class << self
				alias_method_chain( :test, :verbosity ) unless method_defined?(:test_without_verbosity)
			end
		end #unless base.respond_to?(:test_without_verbosity)
#puts base.respond_to?(:method_missing_without_create_object)
#puts base.method_defined?(:method_missing_without_create_object)
#	apparently medding with method_missing is also a bit of an issue
	end

	module ClassMethods

		#	I don't like this quick and dirty name
		def st_model_name
			self.name.demodulize.sub(/Test$/,'')
		end

		def test_with_verbosity(name,&block)
			test_without_verbosity(name,&block)

			test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
			define_method("_#{test_name}_with_verbosity") do
				print "\n#{self.class.name.gsub(/Test$/,'').titleize} #{name}: "
				send("_#{test_name}_without_verbosity")
			end
			#
			#	can't do this.  
			#		alias_method_chain test_name, :verbosity
			#	end up with 2 methods that begin
			#	with 'test_' so they both get run
			#
			alias_method "_#{test_name}_without_verbosity".to_sym,
				test_name
			alias_method test_name,
				"_#{test_name}_with_verbosity".to_sym
		end

		def assert_should_act_as_list(*args)
			options = args.extract_options!
			scope = options[:scope]

			test "#{brand}should act as list" do
				model = create_object.class.name
				model.constantize.destroy_all
				object = create_object
				assert_equal 1, object.position
				attrs = {}
				Array(scope).each do |attr|
					attrs[attr.to_sym] = object.send(attr)
				end if scope
				object = create_object(attrs)
				assert_equal 2, object.position

				# gotta be a relative test as there may already
				# by existing objects (unless I destroy them)
				assert_difference("#{model}.last.position",1) do
					create_object(attrs)
				end
			end

		end

#
#
#	What? No assert_requires_absence method???
#	Its usually conditional so would be pretty pointless
#
#

		def assert_requires_past_date(*attr_names)
			attr_names.each do |attr_name|
				test "should require #{attr_name} be in the past" do
					#	can't assert difference of 1 as may be other errors
					object = create_object( attr_name => Date.yesterday )
					assert !object.errors.on_attr_and_type(attr_name,:not_past_date)
					assert_difference( "#{model_name}.count", 0 ) do
						object = create_object( attr_name => Date.tomorrow )
						assert object.errors.on_attr_and_type(attr_name,:not_past_date)
					end
				end
			end
		end
	
		def assert_requires_complete_date(*attr_names)
			attr_names.each do |attr_name|
				test "should require a complete date for #{attr_name}" do
#
#
#	What?  No successful test?
#
#
					assert_difference( "#{model_name}.count", 1 ) do
						object = create_object( attr_name => "Sept 11, 2001")
						assert !object.errors.on_attr_and_type(attr_name,:not_complete_date)
					end


					assert_difference( "#{model_name}.count", 0 ) do
						object = create_object( attr_name => "Sept 2010")
						assert object.errors.on_attr_and_type(attr_name,:not_complete_date)
					end
					assert_difference( "#{model_name}.count", 0 ) do
						object = create_object( attr_name => "9/2010")
						assert object.errors.on_attr_and_type(attr_name,:not_complete_date)
					end
				end
			end
		end

	end

	module InstanceMethods

		at_exit { 
			puts Dir.pwd() 
			puts Time.now
		}

		def model_name
#			self.class.name.sub(/Test$/,'')
#			self.class.name.demodulize.sub(/Test$/,'')
			self.class.st_model_name
		end

		def method_missing_with_create_object(symb,*args, &block)
			method = symb.to_s
#			if method =~ /^create_(.+)(\!?)$/
			if method =~ /^create_([^!]+)(!?)$/
				factory = if( $1 == 'object' )
#	doesn't work for controllers yet.  Need to consider
#	singular and plural as well as "tests" method.
#	Probably should just use the explicit factory
#	name in the controller tests.
#				self.class.name.sub(/Test$/,'').underscore
					model_name.underscore
				else
					$1
				end
				bang = $2
				options = args.extract_options!
				if bang.blank?
					record = Factory.build(factory,options)
					record.save
					record
				else
					Factory(factory,options)
				end
			else
#				super(symb,*args, &block)
				method_missing_without_create_object(symb,*args, &block)
			end
		end

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

	end	#	InstanceMethods
end	#	CommonLib::ActiveSupportExtension::TestCase
ActiveSupport::TestCase.send(:include,
	CommonLib::ActiveSupportExtension::TestCase)
