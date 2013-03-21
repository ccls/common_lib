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
#		uid = ( user.is_a?(User) ) ? user.uid : user
#		if !uid.blank?
#			@request.session[:calnetuid] = uid
#			stub_ucb_ldap_person()
#			User.find_create_and_update_by_uid(uid)
#
#			CASClient::Frameworks::Rails::Filter.stubs(
#				:filter).returns(true)
#			# No longer using the GatewayFilter stuff.
#			# CASClient::Frameworks::Rails::GatewayFilter.stubs(
#			# :filter).returns(true)
#		end
	end

	def assert_redirected_to_login
#		assert_response :redirect
#		assert_match "https://auth-test.berkeley.edu/cas/login",
#			@response.redirect_url
	end

	def assert_redirected_to_logout
#		assert_response :redirect
#		assert_match "https://auth-test.berkeley.edu/cas/logout",
#			@response.redirect_url
	end

	def assert_logged_in
#		assert_not_nil session[:calnetuid]
	end

	def assert_not_logged_in
#		assert_nil session[:calnetuid]
	end

	def active_user(options={})
		u = Factory(:user, options)
		#	leave this special save here just in case I change things.
		#	although this would need changed for UCB CAS.
		#	u.save_without_session_maintenance
		#	u
	end
	alias_method :user, :active_user

	def superuser(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('superuser')
#		u
	end
#	alias_method :super_user, :superuser

	def administrator(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('administrator')
#		u
	end
#	alias_method :admin, :admin_user
#	alias_method :administrator, :admin_user

#	def interviewer(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('interviewer')
#		u
#	end

	def reader(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('reader')
#		u
	end
#	alias_method :employee, :reader

	def editor(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('editor')
#		u
	end

	def exporter(options={})
#		u = active_user(options)
#		u.roles << Role.find_or_create_by_name('exporter')
#		u
	end

	class << self

		def site_superusers
#			@site_superusers ||= %w( superuser )
		end

		def non_site_superusers
#			@non_site_superusers ||= ( all_test_roles - site_superusers )
		end

		def site_administrators
#			@site_administrators ||= %w( superuser administrator )
		end

		def non_site_administrators
#			@non_site_administrators ||= ( all_test_roles - site_administrators )
		end

		def site_exporters
#			@site_exporters ||= %w( superuser administrator exporter )
		end

		def non_site_exporters
#			@non_site_exporters ||= ( all_test_roles - site_exporters )
		end

		def site_editors
#			@site_editors ||= %w( superuser administrator exporter editor )
		end

		def non_site_editors
#			@non_site_editors ||= ( all_test_roles - site_editors )
		end

		def site_readers
#			@site_readers ||= %w( superuser administrator exporter editor reader )
		end

		def non_site_readers
#			@non_site_readers ||= ( all_test_roles - site_readers )
		end

		def all_test_roles
#			@all_test_roles = %w( superuser administrator exporter editor reader active_user )
		end

	end	#	class << self

end
