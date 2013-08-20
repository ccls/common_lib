source 'https://rubygems.org'

#       Fetching source index from http://gems.rubyforge.org/
#       Could not fetch specs from http://gems.rubyforge.org/
#source "http://gems.rubyforge.org"

source "http://gemcutter.org"
source "http://gems.github.com"



group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :test do

	gem 'rails', '~> 3.2'

	gem 'sqlite3'
#	gem 'jquery-rails'

	#       ruby 1.9.3 requirement to parse american date
	#       format Month/Day/Year Date.parse('12/31/2000')
	gem 'american_date'

	gem "ryanb-acts-as-list", :require => 'acts_as_list'
	
	gem "jeweler"
	gem "hpricot"

	gem "simplecov", :require => false

	gem "ccls-html_test"

	gem 'test-unit'
	
#	gem "factory_girl"
	gem "factory_girl_rails"

#	gem "mocha", '0.10.5', :require => false #	0.11.4
#	gem "mocha", :require => false #	0.11.4
	gem "mocha", '0.13.3', :require => false #	0.14.0 seems to require unstubbing


	gem "autotest-rails", :require => 'autotest/rails'

	gem 'ZenTest', '=4.9.1'

end
