source 'https://rubygems.org'
source "http://gemcutter.org"
source "http://gems.github.com"


group :test do

	gem 'rails'
	gem 'protected_attributes'	#	to keep rails 3 style

	gem 'sqlite3'

	#       ruby 1.9.3 requirement to parse american date
	#       format Month/Day/Year Date.parse('12/31/2000')
	gem 'american_date'

	gem "acts_as_list"
	
	gem "jeweler"
	gem "hpricot"

	#	simplecov-0.8.1 or one of its dependencies causes autotest to not actually run tests?
#	gem "simplecov", '0.7.1', :require => false
	gem "simplecov", :require => false

	gem "ccls-html_test"

	gem 'test-unit'
	
	gem "factory_girl_rails"

#	gem "mocha", '0.10.5', :require => false #	0.11.4
#	gem "mocha", :require => false #	0.11.4
#	gem "mocha", '0.13.3', :require => false #	0.14.0 seems to require unstubbing
	gem "mocha", :require => false #	0.14.0 seems to require unstubbing

	gem "autotest-rails", :require => 'autotest/rails'

	gem 'ZenTest'	#, '=4.9.1'

	gem 'jakewendt-test_with_verbosity'

end
