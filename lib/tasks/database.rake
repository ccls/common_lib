namespace :db do

	desc "Create yml fixtures for given model in database\n" <<
	     "rake db:extract_fixtures_from pages"
	task :extract_fixtures_from => :environment do
		me = $*.shift
		while( table_name = $*.shift )
			File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
				data = table_name.singularize.capitalize.constantize.find(
					:all).collect(&:attributes)
				file.write data.inject({}) { |hash, record|
					record.delete('created_at')
					record.delete('updated_at')
					hash["#{table_name}_#{record['id']}"] = record
					hash
				}.to_yaml
			end
		end
		exit
	end

	desc "Dump MYSQL table descriptions."
	task :describe => :environment do
		puts
		puts "FYI: This task ONLY works on MYSQL databases."
		puts
		config = ActiveRecord::Base.connection.instance_variable_get(:@config)
#=> {:adapter=>"mysql", :host=>"localhost", :password=>nil, :username=>"root", :database=>"my_development", :encoding=>"utf8"}

		tables = ActiveRecord::Base.connection.execute('show tables;')
		while( table = tables.fetch_row ) do
			puts "Table: #{table}"

			#	may have to include host and port
			system("mysql --table=true " <<
				"--user=#{config[:username]} " <<
				"--password='#{config[:password]}' " <<
				"--execute='describe #{table}' " <<
				config[:database]);

			#
			#	mysql formats the table well so doing it by hand is something that
			#	will have to wait until I feel like wasting my time
			#
			#	columns = ActiveRecord::Base.connection.execute("describe #{table};")
			#	while( column = columns.fetch_hash ) do
			#		puts column.keys Extra Default Null Type Field Key
			#	end
		end
	end

end
