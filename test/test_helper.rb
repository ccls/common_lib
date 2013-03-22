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







	def login_as( user=nil )
		user_id = ( user.is_a?(User) ) ? user.id : user
		if !user_id.blank?
			assert_not_logged_in
			s = @request.session[:user_id] = user_id
			assert_logged_in
		else
			assert_not_logged_in
		end
	end

	def assert_redirected_to_login
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	def assert_redirected_to_logout
		assert_redirected_to logout_path
	end

	def assert_logged_in
		assert_not_nil session[:user_id]
	end

	def assert_not_logged_in
		assert_nil session[:user_id]
	end

	def active_user(options={})
		u = Factory(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def administrator(options={})
		u = active_user(options.merge(:role => 'administrator'))
	end

	def editor(options={})
		u = active_user(options.merge(:role => 'editor'))
	end

	def reader(options={})
		u = active_user(options.merge(:role => 'reader'))
	end

	class << self

		def site_administrators
			@site_administrators ||= %w( administrator )
		end

		def non_site_administrators
			@non_site_administrators ||= ( all_test_roles - site_administrators )
		end

		def site_editors
			@site_editors ||= %w( administrator exporter )
		end

		def non_site_editors
			@non_site_editors ||= ( all_test_roles - site_editors )
		end

		def site_readers
			@site_readers ||= %w( administrator editor reader )
		end

		def non_site_readers
			@non_site_readers ||= ( all_test_roles - site_readers )
		end

		def all_test_roles
			@all_test_roles = %w( administrator editor reader )
		end

	end	#	class << self

end
