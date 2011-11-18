ActionController::Routing::Routes.draw do |map|
	map.resources :blogs,
			:shallow => true do |blog|	
		blog.resources :posts
	end

	map.root :controller => :blogs, :action => :index

end
