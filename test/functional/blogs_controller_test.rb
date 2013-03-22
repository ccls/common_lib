require 'test_helper'

class BlogsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Blog',
		:actions => [:new,:create,:edit,:update,:show,:index,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_blog
	}

	def factory_attributes(options={})
#		Factory.attributes_for(:blog,options)
#	using build will create associations which is import if it is a requirement
		Factory.build(:blog,options).attributes
	end

#	assert_access_with_login({    :logins => site_administrators })
#	assert_no_access_with_login({ :logins => non_site_administrators })
#	assert_no_access_without_login

	assert_access_without_login

	assert_no_route :get, :fake_action

	test "should get index" do
		get :index
		assert_response :success
		assert_not_nil assigns(:blogs)
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should create blog" do
		assert_difference('Blog.count') do
			post :create, :blog => new_blog.attributes
		end
		assert_redirected_to blog_path(assigns(:blog))
	end

	test "should not create blog if save fails" do
		Blog.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('Blog.count', 0) do
			post :create, :blog => new_blog.attributes
		end
		assert_response :success
		assert_template 'new'
	end

	test "should show blog" do
		blog = create_blog
		get :show, :id => blog.id
		assert_response :success
	end

	test "should get edit" do
		blog = create_blog
		get :edit, :id => blog.id
		assert_response :success
	end

	test "should update blog" do
		blog = create_blog
		attributes = new_blog.attributes
		attributes.delete('created_at')
		attributes.delete('updated_at')
		put :update, :id => blog.id, :blog => attributes
		assert_redirected_to blog_path(assigns(:blog))
	end

	test "should not update blog if save fails" do
		blog = create_blog
		Blog.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => blog.id, :blog => new_blog.attributes
		assert_response :success
		assert_template 'edit'
	end

	test "should destroy blog" do
		blog = create_blog
		assert_difference('Blog.count', -1) do
			delete :destroy, :id => blog.id
		end
		assert_redirected_to blogs_path
	end
end
