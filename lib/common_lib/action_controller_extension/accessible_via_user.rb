module CommonLib::ActionControllerExtension::AccessibleViaUser

	def self.included(base)
		base.extend ClassMethods
	end

	#	This needs to be static and not dynamic or the multiple
	#	calls that would create it would overwrite each other.
	def nawil_redirection(options={})
		if options[:redirect]
			send(options[:redirect])
		else
			root_path
		end
	end

	module ClassMethods

		def awil_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_login(*actions)
			user_options = actions.extract_options!

			options = {}
# ruby 193 uses symbols
			if ( self.constants.include?(:ASSERT_ACCESS_OPTIONS) )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
#			elsif ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
#				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			logins = Array(options[:logins]||options[:login])
			logins.each do |login|
				#	options[:login] is set for the title,
				#	but "login_as send(login)" as options[:login]
				#	will be the last in the array at runtime.
				options[:login] = login

				test "#{brand}should get new #{awil_title(options)}" do
					login_as send(login)
					args = options[:new] || {}
					send(:get,:new,args)
					assert_response :success
					assert_template 'new'
					assert assigns(m_key), "#{m_key} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:new) || options.keys.include?(:new)
	
				test "#{brand}should post create #{awil_title(options)}" do
					login_as send(login)
					args = if options[:create]
						options[:create]
					elsif options[:attributes_for_create]
						{m_key => send(options[:attributes_for_create])}
					else
						{}
					end
					assert_difference("#{options[:model]}.count",1) do
						send(:post,:create,args)
					end
					assert_response :redirect
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:create) || options.keys.include?(:create)
	
				test "#{brand}should NOT post create #{awil_title(options)} and #{m_key} save fails" do
					login_as send(login)
					#	AFTER login as it may create this resource with the user
					options[:model].constantize.any_instance.stubs(:create_or_update).returns(false)
					args = if options[:create]
						options[:create]
					elsif options[:attributes_for_create]
						{m_key => send(options[:attributes_for_create])}
					else
						{}
					end
					assert_difference("#{options[:model]}.count",0) do
						send(:post,:create,args)
					end
					assert assigns(m_key)
					assert_response :success
					assert_template 'new'
					assert_not_nil flash[:error]
				end if( actions.include?(:create) || options.keys.include?(:create) ) && !options[:skip_create_failure]
	
				test "#{brand}should NOT post create #{awil_title(options)} and invalid #{m_key}" do
					login_as send(login)
					#	AFTER login as it may create this resource with the user
					options[:model].constantize.any_instance.stubs(:valid?).returns(false)
					args = if options[:create]
						options[:create]
					elsif options[:attributes_for_create]
						{m_key => send(options[:attributes_for_create])}
					else
						{}
					end
					assert_difference("#{options[:model]}.count",0) do
						send(:post,:create,args)
					end
					assert assigns(m_key)
					assert_response :success
					assert_template 'new'
					assert_not_nil flash[:error]
				end if( actions.include?(:create) || options.keys.include?(:create) ) && !options[:skip_create_failure]
	
				test "#{brand}should get edit #{awil_title(options)}" do
					login_as send(login)
					args={}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					send(:get,:edit, args)
					assert_response :success
					assert_template 'edit'
					assert assigns(m_key), "#{m_key} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:edit) || options.keys.include?(:edit)
	
				test "#{brand}should NOT get edit #{awil_title(options)} and an invalid id" do
					login_as send(login)
					get :edit, :id => 0
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
				end if( actions.include?(:edit) || options.keys.include?(:edit) ) && !options[:skip_edit_failure]
	
				test "#{brand}should put update #{awil_title(options)}" do
					login_as send(login)
					args={}
					if options[:method_for_create] && options[:attributes_for_create]
						obj = send(options[:method_for_create],
							:updated_at => ( Time.now - 2.days ) )
						args[:id] = obj.id
						args[m_key] = send(options[:attributes_for_create])
					end
					before = obj.updated_at if obj
#					sleep 1 if obj	#	if updated too quickly, updated_at won't change
					send(:put,:update, args)
					after = obj.reload.updated_at if obj
					assert_not_equal( before.to_i,after.to_i, "updated_at did not change." ) if obj
					assert_response :redirect
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:update) || options.keys.include?(:update)
	
				test "#{brand}should NOT put update #{awil_title(options)} and #{m_key} save fails" do
					login_as send(login)
					args=options[:update]||{}
					if options[:method_for_create] && options[:attributes_for_create]
						obj = send(options[:method_for_create],
							:updated_at => ( Time.now - 2.days ) )
						args[:id] = obj.id
						args[m_key] = send(options[:attributes_for_create])
					end
					before = obj.updated_at if obj
#					sleep 1 if obj	#	if updated too quickly, updated_at won't change
					options[:model].constantize.any_instance.stubs(:create_or_update).returns(false)
					send(:put,:update, args)
					after = obj.reload.updated_at if obj
					assert_equal( before.to_s(:db), after.to_s(:db), "updated_at changed." ) if obj
					assert_not_nil flash[:error], "flash[:error] was nil"
					unless options[:no_redirect_check]
						assert_response :success
						assert_template 'edit'
					end
				end if( actions.include?(:update) || options.keys.include?(:update) ) && !options[:skip_update_failure]
	
				test "#{brand}should NOT put update #{awil_title(options)} and invalid #{m_key}" do
					login_as send(login)
					args=options[:update]||{}
					if options[:method_for_create] && options[:attributes_for_create]
						obj = send(options[:method_for_create],
							:updated_at => ( Time.now - 2.days ) )
						args[:id] = obj.id
						args[m_key] = send(options[:attributes_for_create])
					end
					before = obj.updated_at if obj
#					sleep 1 if obj	#	if updated too quickly, updated_at won't change
					options[:model].constantize.any_instance.stubs(:valid?).returns(false)
					send(:put,:update, args)
					after = obj.reload.updated_at if obj
					assert_equal( before.to_s(:db), after.to_s(:db), "updated_at changed." ) if obj
					assert_not_nil flash[:error], "flash[:error] was nil"
					unless options[:no_redirect_check]
						assert_response :success
						assert_template 'edit'
					end
				end if( actions.include?(:update) || options.keys.include?(:update) ) && !options[:skip_update_failure]
	
				test "#{brand}should NOT put update #{awil_title(options)} and an invalid id" do
					login_as send(login)
					put :update, :id => 0
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
				end if( actions.include?(:update) || options.keys.include?(:update) ) && !options[:skip_update_failure]
	
				test "#{brand}should get show #{awil_title(options)}" do
					login_as send(login)
					args={}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					send(:get,:show, args)
					assert_response :success
					assert_template 'show'
					assert assigns(m_key), "#{m_key} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:show) || options.keys.include?(:show)
	
				test "#{brand}should NOT get show #{awil_title(options)} and an invalid id" do
					login_as send(login)
					get :show, :id => 0
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
				end if( actions.include?(:show) || options.keys.include?(:show) ) && !options[:skip_show_failure]
	
				test "#{brand}should delete destroy #{awil_title(options)}" do
					login_as send(login)
					args={}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					assert_difference("#{options[:model]}.count",-1) do
						send(:delete,:destroy,args)
					end
					assert_response :redirect
					assert assigns(m_key), "#{m_key} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:destroy) || options.keys.include?(:destroy)
	
				test "#{brand}should NOT delete destroy #{awil_title(options)} and an invalid id" do
					login_as send(login)
					delete :destroy, :id => 0
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
				end if( actions.include?(:destroy) || options.keys.include?(:destroy) ) && !options[:skip_destroy_failure]
	
				test "#{brand}should get index #{awil_title(options)}" do
					login_as send(login)
					get :index
					assert_response :success
					assert_template 'index'
					assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)), 
						"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:index) || options.keys.include?(:index)
	
				test "#{brand}should get index #{awil_title(options)} and items" do
					send(options[:before]) if !options[:before].blank?
					login_as send(login)
					3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
					get :index
					assert_response :success
					assert_template 'index'
					assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
						"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned."
					assert_nil flash[:error], "flash[:error] was not nil"
				end if actions.include?(:index) || options.keys.include?(:index)

			end	#	logins.each
		end


#	I can't imagine a whole lot of use for this one.

		def assert_access_without_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?(:ASSERT_ACCESS_OPTIONS) )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
#			elsif ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
#				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "#{brand}AWoL should get new without login" do
				get :new
				assert_response :success
				assert_template 'new'
				assert assigns(m_key), "#{m_key} was not assigned."
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:new) || options.keys.include?(:new)

			test "#{brand}AWoL should post create without login" do
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				assert_difference("#{options[:model]}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:create) || options.keys.include?(:create)

#			test "should NOT get edit without login" do
#				args=[]
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args.push(:id => obj.id)
#				end
#				send(:get,:edit, *args)
#				assert_redirected_to_login
#			end if actions.include?(:edit) || options.keys.include?(:edit)
#
#			test "should NOT put update without login" do
#				args={}
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
#					args[options[:factory]] = Factory.attributes_for(options[:factory])
#				end
#				send(:put,:update, args)
#				assert_redirected_to_login
#			end if actions.include?(:update) || options.keys.include?(:update)

			test "#{brand}AWoL should get show without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(m_key), "#{m_key} was not assigned."
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:show) || options.keys.include?(:show)

#			test "should NOT delete destroy without login" do
#				args=[]
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args.push(:id => obj.id)
#				end
#				assert_no_difference("#{options[:model]}.count") do
#					send(:delete,:destroy,*args)
#				end
#				assert_redirected_to_login
#			end if actions.include?(:destroy) || options.keys.include?(:destroy)
#
#			test "should NOT get index without login" do
#				get :index
#				assert_redirected_to_login
#			end if actions.include?(:index) || options.keys.include?(:index)

			test "#{brand}should get index without login" do
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned."
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

			test "#{brand}should get index without login and items" do
				send(options[:before]) if !options[:before].blank?
				3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned."
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

		end

		def nawil_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_no_access_with_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?(:ASSERT_ACCESS_OPTIONS) )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
#			elsif ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
#				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			logins = Array(options[:logins]||options[:login])
				logins.each do |login|
					#	options[:login] is set for the title,
					#	but "login_as send(login)" as options[:login]
					#	will be the last in the array at runtime.
					options[:login] = login
	
				test "#{brand}should NOT get new #{nawil_title(options)}" do
					login_as send(login)
					args = options[:new]||{}
					send(:get,:new,args)
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:new) || options.keys.include?(:new)
	
				test "#{brand}should NOT post create #{nawil_title(options)}" do
					login_as send(login)
					args = if options[:create]
						options[:create]
					elsif options[:attributes_for_create]
						{m_key => send(options[:attributes_for_create])}
					else
						{}
					end
					assert_no_difference("#{options[:model]}.count") do
						send(:post,:create,args)
					end
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:create) || options.keys.include?(:create)
	
				test "#{brand}should NOT get edit #{nawil_title(options)}" do
					login_as send(login)
					args=options[:edit]||{}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					send(:get,:edit, args)
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:edit) || options.keys.include?(:edit)
	
				test "#{brand}should NOT put update #{nawil_title(options)}" do
					login_as send(login)
					args=options[:update]||{}
					if options[:method_for_create] && options[:attributes_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
						args[m_key] = send(options[:attributes_for_create])
					end
					before = obj.updated_at if obj
					send(:put,:update, args)
					after = obj.reload.updated_at if obj
					assert_equal( before.to_s(:db), after.to_s(:db), "updated_at changed." ) if obj
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:update) || options.keys.include?(:update)
	
				test "#{brand}should NOT get show #{nawil_title(options)}" do
					login_as send(login)
					args=options[:show]||{}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					send(:get,:show, args)
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:show) || options.keys.include?(:show)
	
				test "#{brand}should NOT delete destroy #{nawil_title(options)}" do
					login_as send(login)
					args=options[:destroy]||{}
					if options[:method_for_create]
						obj = send(options[:method_for_create])
						args[:id] = obj.id
					end
					assert_no_difference("#{options[:model]}.count") do
						send(:delete,:destroy,args)
					end
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:destroy) || options.keys.include?(:destroy)
	
				test "#{brand}should NOT get index #{nawil_title(options)}" do
					login_as send(login)
					get :index
					assert_not_nil flash[:error], "flash[:error] was nil"
					assert_response :redirect
					unless options[:no_redirect_check]
						assert_redirected_to nawil_redirection(options)
					end
				end if actions.include?(:index) || options.keys.include?(:index)

			end	#	logins.each
		end

		def assert_no_access_without_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?(:ASSERT_ACCESS_OPTIONS) )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
#			elsif ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
#				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "#{brand}should NOT get new without login" do
				get :new
				assert_redirected_to_login
			end if actions.include?(:new) || options.keys.include?(:new)

			test "#{brand}should NOT post create without login" do
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:post,:create,args)
				end
				assert_redirected_to_login
			end if actions.include?(:create) || options.keys.include?(:create)

			test "#{brand}should NOT get edit without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_redirected_to_login
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "#{brand}should NOT put update without login" do
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_equal( before.to_s(:db), after.to_s(:db) ) if obj
				assert_redirected_to_login
			end if actions.include?(:update) || options.keys.include?(:update)

			test "#{brand}should NOT get show without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_redirected_to_login
			end if actions.include?(:show) || options.keys.include?(:show)

			test "#{brand}should NOT delete destroy without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:delete,:destroy,args)
				end
				assert_redirected_to_login
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "#{brand}should NOT get index without login" do
				get :index
				assert_redirected_to_login
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end	# module ClassMethods
end	#	module CommonLib::ActionControllerExtension::AccessibleViaProtocol
ActionController::TestCase.send(:include, 
	CommonLib::ActionControllerExtension::AccessibleViaUser)
