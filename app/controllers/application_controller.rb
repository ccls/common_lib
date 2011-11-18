class ApplicationController < ActionController::Base

	helper :all # include all helpers, all the time

	# See ActionController::RequestForgeryProtection for details
	protect_from_forgery

protected

	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.request_uri
		flash[:error] = message
		redirect_to default
	end


	def redirections
		@redirections ||= HashWithIndifferentAccess.new({
			:not_be_user => {
				:redirect_to => user_path(current_user)
			}
		})
	end

end
