# Some code from jeremymcanally's "pending"
# http://github.com/jeremymcanally/pending/tree/master

module CommonLib::ActiveSupportExtension::Pending
	unless defined?(Spec)	#	I don't think that I ever know what this was for.  Rspec?

#		@@pending_cases = []
#		@@at_exit = false

		def pending(description = "", &block)
			description << ": pending has been deprecated by me.  use skip instead."
			skip( description, block )

#			if description.is_a?(Symbol)
#				is_pending = $tags[description]
#				return block.call unless is_pending
#			end
#
#			if block_given?
#				failed = false
#
#				begin
#					block.call
#				rescue Exception
#					failed = true
#				end
#
#				flunk("<#{description}> did not fail.") unless failed 
#			end
#
#			caller[0] =~ (/(.*):(.*):in `(.*)'/)
##puts __method__	=> 'pending'
#
##puts caller.inspect => 
##	["/Users/jakewendt/github_repo/ccls/odms/test/unit/sample_test.rb:95:in `block in <class:SampleTest>'", "/Users/jakewendt/github_repo/ccls/odms/test/active_support_extension/test_with_verbosity.rb:22:in `block in test_with_verbosity'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/mocha-0.10.5/lib/mocha/integration/mini_test/version_230_to_262.rb:28:in `run'", "/opt/local/lib/ruby1.9/1.9.1/test/unit/testcase.rb:17:in `run'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/testing/setup_and_teardown.rb:36:in `block in run'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/callbacks.rb:425:in `_run__2023670764214928242__setup__504654280789409405__callbacks'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/callbacks.rb:405:in `__run_callback'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/callbacks.rb:385:in `_run_setup_callbacks'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/callbacks.rb:81:in `run_callbacks'", "/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.6/lib/active_support/testing/setup_and_teardown.rb:35:in `run'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:787:in `block in _run_suite'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:780:in `map'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:780:in `_run_suite'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:565:in `block in _run_suites'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:563:in `each'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:563:in `_run_suites'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:746:in `_run_anything'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:909:in `run_tests'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:896:in `block in _run'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:895:in `each'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:895:in `_run'", "/opt/local/lib/ruby1.9/1.9.1/minitest/unit.rb:884:in `run'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:21:in `run'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:326:in `block (2 levels) in autorun'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:27:in `run_once'", "/opt/local/lib/ruby1.9/1.9.1/test/unit.rb:325:in `block in autorun'"]
#
## looks like we lose the name of the 'method' in 1.9.1
##"/Users/jakewendt/github_repo/jakewendt/ucb_ccls_homex/test/unit/subject_test.rb:145:in `block in <class:SubjectTest>'", 
#
##			@@pending_cases << "#{$3} at #{$1}, line #{$2}"
#			#	Gotta remember these as the next Regex will overwrite them.
#			filename   = $1
#			linenumber = $2
##	ruby 1.8.7
##	Hx/Addresses Controller should NOT create new address with employee login and invalid address:
##	ruby 1.9.1
##Hx/Addresses Controller block (2 levels) in <class:AddressesControllerTest>:
#			testmethod = $3
#
#			model  = self.class.to_s.gsub(/Test$/,'').titleize
#			method = testmethod.gsub(/_/,' ').gsub(/^test /,'')
##			@@pending_cases << "#{model} #{method}:\n.\t#{filename} line #{linenumber}"
#			@@pending_cases << "#{filename} line #{linenumber}"
##			@@pending_cases << "#{testmethod} at #{filename}, line #{linenumber}"
#			print "P"
#			
#			@@at_exit ||= begin
#				at_exit do
#					#	For some reason, special characters don't always
#					#	print the way you would expect.  Leading white space (tabs)
#					#	and some carriage returns just weren't happening?
#					#	Is this at_exit doing some parsing??
#					puts "\nPending Cases:"
#					@@pending_cases.each do |test_case|
#						puts test_case
#					end
#					puts " \n"
#				end
#			end
		end	#	def pending(description = "", &block)
	end	#	unless defined?(Spec)
end	#	module ActiveSupportExtension::Pending
ActiveSupport::TestCase.send(:include, CommonLib::ActiveSupportExtension::Pending)
