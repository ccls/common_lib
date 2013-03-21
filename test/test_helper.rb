require 'simplecov_test_helper'	#	should be first for some reason

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
	# Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
	#
	# Note: You'll currently still have to declare fixtures explicitly in integration tests
	# -- they do not yet inherit this setting
	fixtures :all

	# Add more helper methods to be used by all tests here...

	def new_blog(options={})
		Factory.build(:blog,options)
	end

	def create_blog(options={})
		p = new_blog(options)
		p.save
		p
	end

	def create_hash_like(options={})
		p = Factory.build(:hash_like,options)
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

	def create_product(options={})
		product = Factory.build(:product,options)
		product.save
		product
	end

	def create_vendor(options={})
		vendor = Factory.build(:vendor,options)
		vendor.save
		vendor
	end

	def create_user(options={})
		user = Factory.build(:user,options)
		user.save
		user
	end

end
