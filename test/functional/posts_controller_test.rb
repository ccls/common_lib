require 'test_helper'

class PostsControllerTest < ActionController::TestCase
	test "should get index" do
		blog = create_blog
		get :index, :blog_id => blog.id
		assert_response :success
		assert_not_nil assigns(:posts)
	end

	test "should not get index with invalid blog id" do
		get :index, :blog_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get new" do
		blog = create_blog
		get :new, :blog_id => blog.id
		assert_response :success
	end

	test "should create post" do
		blog = create_blog
		assert_difference('Post.count') do
			post :create, :post => new_post.attributes, :blog_id => blog.id
		end
		assert_redirected_to post_path(assigns(:post))
	end

	test "should not create invalid post" do
		blog = create_blog
		#	a test for the field_error stuff in common_lib.rb
		#	a post requires a title so that field will test it
		#	also tests the error_messages helper
		assert_difference('Post.count',0) do
			post :create, :post => {}, :blog_id => blog.id
		end
		assert_response :success
		assert_template 'new'
	end

	test "should not create post when save fails" do
		blog = create_blog
		Post.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('Post.count',0) do
			post :create, :post => new_post.attributes, :blog_id => blog.id
		end
		assert_response :success
		assert_template 'new'
	end

	test "should show post" do
		post = create_post
		get :show, :id => post.id
		assert_response :success
	end

	test "should get edit" do
		post = create_post
		get :edit, :id => post.id
		assert_response :success
	end

	test "should update post" do
		post = create_post
		attributes = new_post.attributes
		attributes.delete('created_at')
		attributes.delete('updated_at')
		put :update, :id => post.id, :post => attributes
		assert_redirected_to post_path(assigns(:post))
	end

	test "should not update post when save fails" do
		post = create_post
		Post.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => post.id, :post => new_post.attributes
		assert_response :success
		assert_template 'edit'
	end

	test "should destroy post" do
		post = create_post
		assert_difference('Post.count', -1) do
			delete :destroy, :id => post.id
		end
		assert_redirected_to blog_posts_path(post.blog)
	end
end
