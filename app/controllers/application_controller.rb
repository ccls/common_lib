class ApplicationController < ActionController::Base

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery

protected

	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.url	#	request_uri
		flash[:error] = message
		redirect_to default
	end

	#	used in roles_controller
	def may_not_be_user_required
		current_user.may_not_be_user?(@user) || access_denied(
			"You may not be this user to do this", user_path(current_user))
	end

#	def redirections
#		@redirections ||= HashWithIndifferentAccess.new({
#			:not_be_user => {
#				:redirect_to => user_path(current_user)
#			}
#		})
#	end

	def current_user	
		@current_user ||= session[:user_id] && User.find(session[:user_id])
	end	

	def logged_in?
		!current_user.nil?
	end

	def current_user_required
		logged_in? || 
			access_denied("You must be logged in to do that",login_path)
	end
	alias_method :login_required, :current_user_required

	def no_current_user_required
		logged_in? &&
			access_denied("You must be logged out to do that",root_path)
	end
	alias_method :no_login_required, :no_current_user_required

end
