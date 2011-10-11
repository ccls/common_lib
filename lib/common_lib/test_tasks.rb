module SimplyHelpful;end
namespace :test do
	namespace :units do
		Rake::TestTask.new(:simply_helpful => "db:test:prepare") do |t|
			t.pattern = File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/unit/helpful/*_test.rb'))
			t.libs << "test"
			t.verbose = true
		end
	end
	namespace :functionals do
		Rake::TestTask.new(:simply_helpful => "db:test:prepare") do |t|
			t.pattern = File.expand_path(File.join(
				File.dirname(__FILE__),'/../../test/functional/helpful/*_test.rb'))
			t.libs << "test"
			t.verbose = true
		end
	end
end
Rake::Task['test:functionals'].prerequisites.unshift(
	"test:functionals:simply_helpful" )
Rake::Task['test:units'].prerequisites.unshift(
	"test:units:simply_helpful" )

#	I thought of possibly just including this file
#	but that would make __FILE__ different.
#	Hmmm

#
#	used in simply_helpful's rake test:coverage to run gem's 
#		tests in the context of the application
#
@gem_test_dirs ||= []
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/unit/helpful/'))


#
#	No functional tests so...
#
#/Library/Ruby/Gems/1.8/gems/rcov-0.9.9/bin/rcov:516:in `load': no such file to load -- /Library/Ruby/Gems/1.8/gems/ccls-simply_helpful-2.2.12/test/functional/helpful/*_test.rb (LoadError)
#	from /Library/Ruby/Gems/1.8/gems/rcov-0.9.9/bin/rcov:516
#	from /usr/bin/rcov:19:in `load'
#	from /usr/bin/rcov:19
#
#	Actually, I think the error is because the directory isn't there
#	because there aren't any files in the gem in that directory.
#	Perhaps I could try to force it.  Until then, comment this line out.
#
#@gem_test_dirs << File.expand_path(File.join(File.dirname(__FILE__),
#	'/../../test/functional/helpful/'))

#
#	More flexible. Find all test files, pick out their dir, uniq 'em and add.
#
Dir.glob( File.expand_path(File.join(File.dirname(__FILE__),
	'/../../test/*/helpful/*_test.rb'))
).collect{|f|
	File.dirname(f)
}.uniq.each{ |dir|
	@gem_test_dirs << dir
}
