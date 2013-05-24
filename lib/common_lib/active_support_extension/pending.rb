# Some code from jeremymcanally's "pending"
# https://github.com/jeremymcanally/pending/tree/master

module ActiveSupport
	module Testing
		module Pending

			unless defined?(Spec)

				@@pending_cases = []
				@@at_exit = false

				def pending(description = "No description given", &block)
#	just because its defined doesn't mean that the skip method exists
#	this should be is_a?(MiniTest::Unit::TestCase)
#					if defined?(::MiniTest)
#					if defined?(::MiniTest) and self.is_a?(::MiniTest::Unit::TestCase)
#						skip(description.blank? ? nil : description)
#					else
						if description.is_a?(Symbol)
							is_pending = $tags[description]
							return block.call unless is_pending
						end

						if block_given?
							failed = false

							begin
								block.call
							rescue Exception
								failed = true
							end

							flunk("<#{description}> did not fail.") unless failed
						end

#	The original
#						caller[0] =~ (/(.*):(.*):in `(.*)'/)
#						@@pending_cases << "#{$3} at #{$1}, line #{$2}"
#

#	Old notes
#						caller[0] =~ (/(.*):(.*):in `(.*)'/)
#						@@pending_cases << "#{$3} at #{$1}, line #{$2}"
#
##	caller[0] will be like ...
##	"/Users/jakewendt/github_repo/ccls/odms/test/unit/sample_test.rb:95:in `block in <class:SampleTest>'"
#						#	looks like we lose the name of the 'method' in 1.9.1
#
#						#	Gotta remember these as the next Regex will overwrite them.
#						filename   = $1
#						linenumber = $2
#
###	ruby 1.8.7
###	Hx/Addresses Controller should NOT create new address with employee login and invalid address:
###	ruby 1.9.1
###Hx/Addresses Controller block (2 levels) in <class:AddressesControllerTest>:
#
##						testmethod = $3
##			model  = self.class.to_s.gsub(/Test$/,'').titleize
##			method = testmethod.gsub(/_/,' ').gsub(/^test /,'')
###			@@pending_cases << "#{model} #{method}:\n.\t#{filename} line #{linenumber}"
#						@@pending_cases << "#{filename} line #{linenumber}"
###			@@pending_cases << "#{testmethod} at #{filename}, line #{linenumber}"
#

#	"/Users/jakewendt/github_repo/ccls/odms/test/unit/sample_test.rb:95:in `block in <class:SampleTest>'"
						caller[0] =~ (/(.*):(.*):in `(.*)'/)

#	self.to_s => test_should_be_pending(RoleTest)

#						@@pending_cases << "#{$3} at #{$1}, line #{$2}"
#						@@pending_cases << ["#{self.to_s} [#{$1}:#{$2}]",description]
						@@pending_cases << [self.to_s,"[#{$1}:#{$2}]",description]

#  1) Skipped:
#test_should_not_update_attribute_if_new_data_is_blank(BcInfoTest) [/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.13/lib/active_support/testing/pending.rb:15]:
#Skipped, no message given
#
#  2) Skipped:
#test_should_send_save_failed_notification_if_subject_changed_and_save_failed(BcInfoTest) [/opt/local/lib/ruby1.9/gems/1.9.1/gems/activesupport-3.2.13/lib/active_support/testing/pending.rb:15]:
#Skipped, no message given


#	making the output look more similar to "skip"
#	probably should reincorporate this into CommonLib

						print "P"

						@@at_exit ||= begin
							at_exit do
								puts "\nPending Cases:"
#								@@pending_cases.each do |test_case|
								@@pending_cases.each_with_index do |test_case,i|
#									puts " #{i+1}) Pending:"
									printf "%4d) Pending:\n", i+1
									puts test_case
#	if i just puts the array it will append carriage returns after each element
#									puts test_case[0]
#									puts test_case[1]
									puts
								end
								puts
							end
						end

#					end	#	if defined?(::MiniTest)

				end	#	def pending(description = "", &block)

			end	#	unless defined?(Spec)

		end	#	module Pending
	end	#	module Testing
end	#	module ActiveSupport
