ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

#$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
#	not true if the task is corrected, which I now think is (not included here at the mo)

class ActiveSupport::TestCase
#	self.use_transactional_fixtures = true
#	self.use_instantiated_fixtures  = false

	fixtures :all

	def new_blog(options={})
		Factory.build(:blog,options)
	end

	def create_blog(options={})
		p = new_blog(options)
		p.save
		p
	end

	def new_post(options={})
		Factory.build(:post,options)
	end

	def create_post(options={})
		p = new_post(options)
		p.save
		p
	end

end
