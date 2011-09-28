ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

#$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
#	not true if the task is corrected, which I now this is

class ActiveSupport::TestCase
	fixtures :all
end
