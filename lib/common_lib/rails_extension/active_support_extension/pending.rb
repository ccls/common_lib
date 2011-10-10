# Some code from jeremymcanally's "pending"
# http://github.com/jeremymcanally/pending/tree/master

module CommonLib::RailsExtension::ActiveSupportExtension::Pending
	unless defined?(Spec)

		@@pending_cases = []
		@@at_exit = false

		def pending(description = "", &block)
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

			caller[0] =~ (/(.*):(.*):in `(.*)'/)
#puts caller.inspect

# looks like we lose the name of the 'method' in 1.9.1
#"/Users/jakewendt/github_repo/jakewendt/ucb_ccls_homex/test/unit/subject_test.rb:145:in `block in <class:SubjectTest>'", 

#			@@pending_cases << "#{$3} at #{$1}, line #{$2}"
			#	Gotta remember these as the next Regex will overwrite them.
			filename   = $1
			linenumber = $2
#	ruby 1.8.7
#	Hx/Addresses Controller should NOT create new address with employee login and invalid address:
#	ruby 1.9.1
#Hx/Addresses Controller block (2 levels) in <class:AddressesControllerTest>:
			testmethod = $3

			model  = self.class.to_s.gsub(/Test$/,'').titleize
			method = testmethod.gsub(/_/,' ').gsub(/^test /,'')
			@@pending_cases << "#{model} #{method}:\n.\t#{filename} line #{linenumber}"
#			@@pending_cases << "#{testmethod} at #{filename}, line #{linenumber}"
			print "P"
			
			@@at_exit ||= begin
				at_exit do
					#	For some reason, special characters don't always
					#	print the way you would expect.  Leading white space (tabs)
					#	and some carriage returns just weren't happening?
					#	Is this at_exit doing some parsing??
					puts "\nPending Cases:"
					@@pending_cases.each do |test_case|
						puts test_case
					end
					puts " \n"
				end
			end
		end
	end
end
ActiveSupport::TestCase.send(:include, 
	CommonLib::RailsExtension::ActiveSupportExtension::Pending)
