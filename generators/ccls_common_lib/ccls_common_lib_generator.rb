class CclsCommonLibGenerator < Rails::Generator::Base

	def manifest
		#	See Rails::Generator::Commands::Create
		#	rails-2.3.10/lib/rails_generator/commands.rb
		#	for code methods for record (Manifest)
		record do |m|
			m.directory('config/autotest')
			m.file('autotest_common_lib.rb', 'config/autotest/common_lib.rb')
			m.directory('lib/tasks')
			m.file('common_lib.rake', 'lib/tasks/common_lib.rake')

#			File.open('Rakefile','a'){|f| 
#				f.puts <<-EOF
##	From `script/generate common_lib` ...
#require 'common_lib/test_tasks'
#				EOF
#			}
#
#			File.open('.autotest','a'){|f| 
#				f.puts <<-EOF
##	From `script/generate common_lib` ...
#require 'common_lib/autotest'
#				EOF
#			}

#			%w( ).each do |migration|
#				m.migration_template "migrations/#{migration}.rb",
#					'db/migrate', :migration_file_name => migration
#			end
			dot = File.dirname(__FILE__)
			m.directory('public/javascripts')
			Dir["#{dot}/templates/javascripts/*js"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/javascripts/#{File.basename(file)}")
			}
			m.directory('public/stylesheets')
			Dir["#{dot}/templates/stylesheets/*css"].each{|file| 
				f = file.split('/').slice(-2,2).join('/')
				m.file(f, "public/stylesheets/#{File.basename(file)}")
			}

#			m.directory('public/images')
#			%w( full large medium original small ).each do |style|
#				m.directory("public/images/#{style}")
#				m.file("images/#{style}/missing.png",
#					"public/images/#{style}/missing.png")
#			end

#			m.directory('test/functional/helpful')
#			Dir["#{dot}/templates/functional/*rb"].each{|file| 
#				f = file.split('/').slice(-2,2).join('/')
#				m.file(f, "test/functional/helpful/#{File.basename(file)}")
#			}
#			m.directory('test/unit/helpful')
#			Dir["#{dot}/templates/unit/*rb"].each{|file| 
#				f = file.split('/').slice(-2,2).join('/')
#				m.file(f, "test/unit/helpful/#{File.basename(file)}")
#			}
		end
	end

end
module Rails::Generator::Commands
	class Create
		def migration_template(relative_source, 
				relative_destination, template_options = {})
			migration_directory relative_destination
			migration_file_name = template_options[
				:migration_file_name] || file_name
			if migration_exists?(migration_file_name)
				puts "Another migration is already named #{migration_file_name}: #{existing_migrations(migration_file_name).first}: Skipping" 
			else
				template(relative_source, "#{relative_destination}/#{next_migration_string}_#{migration_file_name}.rb", template_options)
			end
		end
	end #	Create
	class Base
	protected
		#	the loop through migrations happens so fast
		#	that they all have the same timestamp which
		#	won't work when you actually try to migrate.
		#	All the timestamps MUST be unique.
		def next_migration_string(padding = 3)
			@s = (!@s.nil?)? @s.to_i + 1 : if ActiveRecord::Base.timestamped_migrations
				Time.now.utc.strftime("%Y%m%d%H%M%S")
			else
				"%.#{padding}d" % next_migration_number
			end
		end
	end	#	Base
end
