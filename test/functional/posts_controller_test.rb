require 'test_helper'

class PostsControllerTest < ActionController::TestCase
	test "should get index" do
		blog = create_blog
		get :index, :blog_id => blog.id
		assert_response :success
		assert_not_nil assigns(:posts)
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
		put :update, :id => post.id, :post => new_post.attributes
		assert_redirected_to post_path(assigns(:post))
	end

	test "should destroy post" do
		post = create_post
		assert_difference('Post.count', -1) do
			delete :destroy, :id => post.id
		end
		assert_redirected_to blog_posts_path(post.blog)
	end
end
