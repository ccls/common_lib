# From `script/generate ccls_common_lib` ...
# condition added to allow clean 'rake gems:install'
unless Gem.source_index.find_name('ccls-common_lib').empty?
	gem 'ccls-common_lib'
	require 'common_lib/tasks'
	require 'common_lib/test_tasks'
end
