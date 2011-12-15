require(File.join(File.dirname(__FILE__), 'config', 'boot'))

# Use the updated rdoc gem rather than version
# included with ruby.
require 'rdoc'
require 'rdoc/rdoc'

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Generate documentation for the gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
	rdoc.rdoc_dir = 'rdoc'
	rdoc.title		= 'CCLS Common Lib'
	rdoc.options << '--line-numbers' #<< '--inline-source'
	rdoc.rdoc_files.include('README')
	rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'tasks/rails'

begin
	require 'jeweler'
	Jeweler::Tasks.new do |gem|

		gem.name = "ccls-common_lib"
		gem.summary = %Q{CCLS Common Lib gem}
		gem.description = %Q{CCLS Common Lib gem}
		gem.email = "github@jakewendt.com"
		gem.homepage = "http://github.com/ccls/common_lib"
		gem.authors = ["George 'Jake' Wendt"]
		# gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings

		gem.files  = FileList['rails/init.rb']
		gem.files += FileList['lib/**/*.rb']
		gem.files += FileList['lib/**/*.rake']
		gem.files += FileList['generators/**/*']
		gem.files -= FileList['**/versions/*']
#   
#		I'm not quite sure if it matters whether these files
#		are included as 'files' or 'test_files', but
#		they need to be included if I'm gonna use'em.
#
		gem.test_files  = FileList['test/unit/common_lib/*.rb']

		gem.add_dependency('rails', '~> 2')
#	had to explicitly add rails components as greater
#	versions were being loaded 
		gem.add_dependency('activerecord', '~> 2')
		gem.add_dependency('activeresource', '~> 2')
		gem.add_dependency('activesupport', '~> 2')
		gem.add_dependency('actionpack', '~> 2')
		gem.add_dependency('ryanb-acts-as-list')
		gem.add_dependency('ssl_requirement', '>= 0.1.0')

#	Trying to remove Chronic
#		gem.add_dependency('chronic')

#	moved to 'development' dependency to see if it makes any difference
		gem.add_development_dependency('thoughtbot-factory_girl')
		#	adding these as well to see what happens
		gem.add_development_dependency( 'ccls-html_test' )
		gem.add_development_dependency( 'rcov' )
		gem.add_development_dependency( 'mocha' )
		gem.add_development_dependency( 'autotest-rails' )
		gem.add_development_dependency( 'ZenTest' )
	end
	Jeweler::GemcutterTasks.new
rescue LoadError
	puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


#	This is an array of Regexs excluded from test coverage report.
#RCOV_EXCLUDES = ['lib/ccls_engine.rb','lib/ccls_engine/shared_database.rb',
#	'app/models/search.rb','lib/ccls_engine/factories.rb',
#	'lib/ccls_engine/controller.rb']
#
#	a lot of the common_lib code isn't tested in the gem
#


