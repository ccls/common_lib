class Autotest::Rails

#
#	Need both the mapping and the extra files
#
	def run_with_common_lib
		add_exception %r%config/%
		add_exception %r%versions/%
		add_exception %r%\.git/%
		self.extra_files << File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/unit/common_lib/'))

		add_mapping( 
			%r{^#{File.expand_path(File.join(File.dirname(__FILE__),'/../../test/'))}/unit/common_lib/.*_test\.rb$}
			) do |filename, _|
			filename
		end

#
#	common_lib has no functional/common_lib/ tests, so why bother.
#
#		self.extra_files << File.expand_path(File.join(
#				File.dirname(__FILE__),'/../../test/functional/common_lib/'))
#
#	original with both unit and functional
#		add_mapping( 
#			%r{^#{File.expand_path(File.join(File.dirname(__FILE__),'/../../test/'))}/(unit|functional)/common_lib/.*_test\.rb$}
#			) do |filename, _|
#			filename
#		end

		run_without_common_lib
	end
	alias_method_chain :run, :common_lib


end
