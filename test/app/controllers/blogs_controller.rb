class BlogsController < ApplicationController

	def index
		@blogs = Blog.all
	end

	def show
		@blog = Blog.find(params[:id])
	end

	def new
		@blog = Blog.new
	end

	def edit
		@blog = Blog.find(params[:id])
	end

	def create
		@blog = Blog.new(params[:blog])
		if @blog.save
			redirect_to(@blog, :notice => 'Blog was successfully created.')
		else
			render :action => "new"
		end
	end

	def update
		@blog = Blog.find(params[:id])

		if @blog.update_attributes(params[:blog])
			redirect_to(@blog, :notice => 'Blog was successfully updated.')
		else
			render :action => "edit"
		end
	end

	def destroy
		@blog = Blog.find(params[:id])
		@blog.destroy
		redirect_to(blogs_url)
	end
end
