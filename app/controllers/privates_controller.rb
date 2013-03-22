class PrivatesController < ApplicationController

	before_filter :login_required

	before_filter :valid_id_required,
		:only => [:show,:edit,:update,:destroy]

	before_filter :is_administrator_required

	def index
		@privates = Private.all
	end

	def new
		@private = Private.new
	end

	def create
		@private = Private.new(params[:private])
		@private.save!
		flash[:notice] = "Private successfully created!"
		redirect_to @private
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Private creation failed."
		render :action => 'new'
	end

	def update
		@private.update_attributes!(params[:private])
		flash[:notice] = "Private successfully updated!"
		redirect_to @private
	rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
		flash.now[:error] = "Private update failed."
		render :action => 'edit'
	end

	def destroy
		@private.destroy
		redirect_to privates_path
	end

protected

	def valid_id_required
		if Private.exists?(params[:id])
			@private = Private.find(params[:id])
		else
			access_denied("Valid private id required")
		end
	end

	def is_administrator_required
		( current_user.role == 'administrator' ) || access_denied(
			"You don't have permission to do that" )
	end

end
