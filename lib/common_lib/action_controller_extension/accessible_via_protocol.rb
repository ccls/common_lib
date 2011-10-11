module CommonLib::ActionControllerExtension::AccessibleViaProtocol

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def awihttp_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_http(*actions)
			user_options = actions.extract_options!

			options = {
				:login => :admin 
			}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "#{brand}AWiHTTP should get new #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args = options[:new] || {}
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:new) || options.keys.include?(:new)

			test "#{brand}AWiHTTP should post create #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
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

			test "#{brand}AWiHTTP should get edit #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_response :success
				assert_template 'edit'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "#{brand}AWiHTTP should put update #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				sleep 1 if obj  # if updated too quickly, updated_at won't change
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_not_equal( before.to_i,after.to_i, "updated_at did not change" ) if obj
				assert_response :redirect
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:update) || options.keys.include?(:update)

			test "#{brand}AWiHTTP should get show #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:show) || options.keys.include?(:show)

			test "#{brand}AWiHTTP should delete destroy #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_difference("#{options[:model]}.count",-1) do
					send(:delete,:destroy,args)
				end
				assert_response :redirect
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "#{brand}AWiHTTP should get index #{awihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)), 
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

			test "#{brand}AWiHTTP should get index #{awihttp_title(options)} and items" do
				turn_https_off
				send(options[:before]) if !options[:before].blank?
				login_as send(options[:login])
				3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

		end

		def awihttps_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_https(*actions)
			user_options = actions.extract_options!

			options = {
				:login => :admin
			}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "#{brand}AWiHTTPS should get new #{awihttps_title(options)}" do
				login_as send(options[:login])
				args = options[:new] || {}
				turn_https_on
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:new) || options.keys.include?(:new)

			test "#{brand}AWiHTTPS should post create #{awihttps_title(options)}" do
				login_as send(options[:login])
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				turn_https_on
				assert_difference("#{options[:model]}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:create) || options.keys.include?(:create)

			test "#{brand}AWiHTTPS should get edit #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				send(:get,:edit, args)
				assert_response :success
				assert_template 'edit'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "#{brand}AWiHTTPS should put update #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				sleep 1 if obj  # if updated too quickly, updated_at won't change
				turn_https_on
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_not_equal( before.to_i,after.to_i, "updated_at did not change" ) if obj
				assert_response :redirect
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:update) || options.keys.include?(:update)

			test "#{brand}AWiHTTPS should get show #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:show) || options.keys.include?(:show)

			test "#{brand}AWiHTTPS should delete destroy #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				assert_difference("#{options[:model]}.count",-1) do
					send(:delete,:destroy,args)
				end
				assert_response :redirect
				assert assigns(m_key), "#{m_key} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "#{brand}AWiHTTPS should get index #{awihttps_title(options)}" do
				login_as send(options[:login])
				turn_https_on
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

			test "#{brand}AWiHTTPS should get index #{awihttps_title(options)} and items" do
				send(options[:before]) if !options[:before].blank?
				login_as send(options[:login])
				3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
				turn_https_on
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym)),
					"#{m_key.try(:to_s).try(:pluralize).try(:to_sym)} was not assigned"
				assert_nil flash[:error], "flash[:error] was not nil"
			end if actions.include?(:index) || options.keys.include?(:index)

		end

		def nawihttp_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_no_access_with_http(*actions)
			user_options = actions.extract_options!

			options = {
				:login => :admin
			}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "#{brand}NAWiHTTP should NOT get new #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args = options[:new]||{}
				send(:get,:new,args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'new', :protocol => "https://")
			end if actions.include?(:new) || options.keys.include?(:new)

			test "#{brand}NAWiHTTP should NOT post create #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
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
				assert_match @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'create', :protocol => "https://"),@response.redirected_to
			end if actions.include?(:create) || options.keys.include?(:create)

			test "#{brand}NAWiHTTP should NOT get edit #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:edit]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'edit', :id => args[:id], :protocol => "https://")
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "#{brand}NAWiHTTP should NOT put update #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_equal( before.to_s(:db), after.to_s(:db), "updated_at changed" ) if obj
				assert_match @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'update', :id => args[:id], :protocol => "https://"), @response.redirected_to
			end if actions.include?(:update) || options.keys.include?(:update)

			test "#{brand}NAWiHTTP should NOT get show #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:show]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'show', :id => args[:id], :protocol => "https://")
			end if actions.include?(:show) || options.keys.include?(:show)

			test "#{brand}NAWiHTTP should NOT delete destroy #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:destroy]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:delete,:destroy,args)
				end
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'destroy', :id => args[:id], :protocol => "https://")
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "#{brand}NAWiHTTP should NOT get index #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				get :index
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'index', :protocol => "https://")
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end	# module ClassMethods
end	#	module CommonLib::ActionControllerExtension::AccessibleViaProtocol
ActionController::TestCase.send(:include, 
	CommonLib::ActionControllerExtension::AccessibleViaProtocol)
