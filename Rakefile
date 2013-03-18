#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

CommonLib::Application.load_tasks


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

#		gem.files  = FileList['rails/init.rb']
		gem.files  = FileList['lib/**/*.rb']
		gem.files += FileList['lib/**/*.rake']
		gem.files += FileList['vendor/**/*.js']
		gem.files += FileList['vendor/**/*.css']
#		gem.files += FileList['generators/**/*']
		gem.files -= FileList['**/versions/*']
#   
#		I'm not quite sure if it matters whether these files
#		are included as 'files' or 'test_files', but
#		they need to be included if I'm gonna use'em.
#
#		gem.test_files  = FileList['test/unit/common_lib/*.rb']

#		gem.add_dependency('rails', '~> 2')
##	had to explicitly add rails components as greater
##	versions were being loaded 
#		gem.add_dependency('activerecord', '~> 2')
#		gem.add_dependency('activeresource', '~> 2')
#		gem.add_dependency('activesupport', '~> 2')
#		gem.add_dependency('actionpack', '~> 2')
#		gem.add_dependency('ryanb-acts-as-list')
#		gem.add_dependency('ssl_requirement', '>= 0.1.0')

#	Trying to remove Chronic
#		gem.add_dependency('chronic')

#	moved to 'development' dependency to see if it makes any difference
#	It appears that a development dependency won't install,
#	but will still challenge on uninstall if other gems uses.
#	I don't know how true that actually is.
#	'rake install' does actually install factory_girl, if not installed.
#	Don't know how 'development' gets flagged here.
#
#		gem.add_development_dependency('thoughtbot-factory_girl')
#		#	adding these as well to see what happens
#		gem.add_development_dependency( 'ccls-html_test' )
#		gem.add_development_dependency( 'rcov' )
#		gem.add_development_dependency( 'mocha' )
#		gem.add_development_dependency( 'autotest-rails' )
#		gem.add_development_dependency( 'ZenTest' )
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


