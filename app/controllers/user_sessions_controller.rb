class UserSessionsController < ApplicationController

#	skip_before_filter :login_required, :only => [:new, :create]
#	before_filter :no_current_user_required, :only => [:new, :create]

	def new
	end

#	def destroy
#		session.destroy
#		flash[:notice] = "You've been logged out"
#		redirect_to root_path
#	end

end
