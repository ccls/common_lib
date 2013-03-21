require 'test_helper'

class PostTest < ActiveSupport::TestCase

	assert_should_create_default_object

	assert_should_act_as_list( :scope => :blog_id )
	assert_should_require_attributes( :title )
	assert_should_require_attribute_length( :title, :maximum => 250 )
	assert_should_not_require_attributes( :body)
	assert_should_protect_attributes( :id )
	assert_should_not_protect_attributes( :body )
	assert_should_not_require_unique_attributes( :body )

	assert_should_initially_belong_to(:blog)
	assert_should_belong_to( :user, :foreign_key => 'author_id' )

	test "changing title should not change created_at" do
		#	a test for deny_changes
		post = Factory(:post)
		deny_changes("Post.find(#{post.id}).created_at") {
			post.update_attributes(:title => "my new title")
		}
	end

	test "changing title should change updated_at" do
		#	a test for assert_changes
		post = Factory(:post)
		assert_changes("Post.find(#{post.id}).updated_at") {
			post.update_attributes(:title => "my new title")
		}
	end

protected

	#	create_object is called from within the common class tests
	alias_method :create_object, :create_post

end
