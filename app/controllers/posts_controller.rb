class PostsController < ApplicationController

	before_filter :require_blog_id,
		:only => [ :new, :create, :index ]

	def index
		@posts = Post.all
	end

	def show
		@post = Post.find(params[:id])
	end

	def new
		@post = Post.new
	end

	def edit
		@post = Post.find(params[:id])
	end

	def create
		@post = Post.new(params[:post].merge(:blog_id => params[:blog_id]))
		if @post.save
			redirect_to(@post, :notice => 'Post was successfully created.')
		else
			render :action => "new"
		end
	end

	def update
		@post = Post.find(params[:id])
		if @post.update_attributes(params[:post])
			redirect_to(@post, :notice => 'Post was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		redirect_to(blog_posts_url(@post.blog))
	end

protected

	def require_blog_id
		if !params[:blog_id].blank? and Blog.exists?(params[:blog_id])
			@blog = Blog.find(params[:blog_id])
		else
			access_denied("Valid blog id required!", root_path)
		end
	end

end
