module CommonLib;end
namespace :test do
	namespace :units do
		Rake::TestTask.new(:common_lib => "db:test:prepare") do |t|
			t.pattern = File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/unit/common_lib/*_test.rb'))
			t.libs << "test"
			t.verbose = true
		end
	end
#
#	common_lib has no functional/common_lib/ tests,
#		so why bother.
#
#	namespace :functionals do
#		Rake::TestTask.new(:common_lib => "db:test:prepare") do |t|
#			t.pattern = File.expand_path(File.join(
#				File.dirname(__FILE__),'/../../test/functional/common_lib/*_test.rb'))
#			t.libs << "test"
#			t.verbose = true
#		end
#	end
end
#Rake::Task['test:functionals'].prerequisites.unshift(
#	"test:functionals:common_lib" )
Rake::Task['test:units'].prerequisites.unshift(
	"test:units:common_lib" )

#	I thought of possibly just including this file
#	but that would make __FILE__ different.
#	Hmmm

#
#	used in common_lib's rake test:coverage to run gem's 
#		tests in the context of the application
#
@gem_test_dirs ||= []
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/unit/common_lib/'))


#
#	No functional tests so...
#
#/Library/Ruby/Gems/1.8/gems/rcov-0.9.9/bin/rcov:516:in `load': no such file to load -- /Library/Ruby/Gems/1.8/gems/ccls-common_lib-2.2.12/test/functional/common_lib/*_test.rb (LoadError)
#	from /Library/Ruby/Gems/1.8/gems/rcov-0.9.9/bin/rcov:516
#	from /usr/bin/rcov:19:in `load'
#	from /usr/bin/rcov:19
#
#	Actually, I think the error is because the directory isn't there
#	because there aren't any files in the gem in that directory.
#	Perhaps I could try to force it.  Until then, comment this line out.
#
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/functional/common_lib/'))

#
#	More flexible. Find all test files, pick out their dir, uniq 'em and add.
#
Dir.glob( File.expand_path(File.join(File.dirname(__FILE__),
	'/../../test/*/common_lib/*_test.rb'))
).collect{|f|
	File.dirname(f)
}.uniq.each{ |dir|
	@gem_test_dirs << dir
}
