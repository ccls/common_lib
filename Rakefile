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
		gem.files  = FileList['lib/**/*.rb']
		gem.files += FileList['lib/**/*.rake']
		gem.files += FileList['vendor/**/*.js']
		gem.files += FileList['vendor/**/*.css']
		gem.files -= FileList['**/versions/*']
	end
	Jeweler::GemcutterTasks.new
rescue LoadError
	puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
