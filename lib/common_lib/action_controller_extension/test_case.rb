module CommonLib::ActionControllerExtension::TestCase

	def turn_https_on
		@request.env['HTTPS'] = 'on'
#		@request.env['HTTP_X_FORWARDED_PROTO'] == 'https'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end	#	module CommonLib::ActionControllerExtension::TestCase
ActionController::TestCase.send(:include,
	CommonLib::ActionControllerExtension::TestCase)
