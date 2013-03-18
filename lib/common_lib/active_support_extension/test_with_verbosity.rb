module CommonLib::ActiveSupportExtension::TestWithVerbosity

	def self.included(base)
		base.extend(ClassMethods)

		base.class_eval do
			class << self
				alias_method_chain( :test, :verbosity 
					) unless method_defined?(:test_without_verbosity)
			end
		end #unless base.respond_to?(:test_without_verbosity)
	end

	module ClassMethods

		def test_with_verbosity(name,&block)
			test_without_verbosity(name,&block)

			test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
			define_method("_#{test_name}_with_verbosity") do
				print "\n#{self.class.name.gsub(/Test$/,'').titleize} #{name}: "
				send("_#{test_name}_without_verbosity")
			end
			#
			#	can't do this...
			#		alias_method_chain test_name, :verbosity
			#	end up with 2 methods that begin
			#	with 'test_' so they both get run
			#
			alias_method "_#{test_name}_without_verbosity".to_sym,
				test_name
			alias_method test_name,
				"_#{test_name}_with_verbosity".to_sym
		end

	end	#	ClassMethods

end	#	ActiveSupportExtension::TestWithVerbosity
ActiveSupport::TestCase.send(:include, CommonLib::ActiveSupportExtension::TestWithVerbosity)
__END__
