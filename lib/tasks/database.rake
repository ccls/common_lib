class Hash
	#	From http://snippets.dzone.com/posts/show/5811
  # Renaming and replacing the to_yaml function so it'll serialize hashes sorted (by their keys)
  # Original function is in /usr/lib/ruby/1.8/yaml/rubytypes.rb
  def to_ordered_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sort.each do |k, v|   # <-- here's my addition (the 'sort')
#	The above sort, sorts the main yaml 'keys' or fixture labels.
#	k is a fixture label here, eg. "pages_001"
#	v is the attributes hash
#	The hash attributes are NOT sorted, unfortunately.
#	Still working on that one.
          map.add( k, v )


#pages_001:
#  position: 1
#  menu_en: CCLS
#  body_es:
        end
      end
    end
  end
end

namespace :app do
namespace :db do

	desc "Create yml fixtures for given model in database\n" <<
	     "rake app:db:extract_fixtures_from pages"
	task :extract_fixtures_from => :environment do
		me = $*.shift
		while( table_name = $*.shift )
#			File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
			File.open("#{Rails.root}/db/#{table_name}.yml", 'w') do |file|
#				data = table_name.singularize.capitalize.constantize.find(
#				data = table_name.singularize.classify.constantize.find(
#					:all).collect(&:attributes)
#	Added unscoped to break any default scope and sort by id to add some order.
#	Doesn't seem to actually work though.  Still not sorted properly.
#	Cause the result is an unordered hash. Bummer
#	Still use unscoped, just in case there is a default scope with a limit.
#	
				data = table_name.singularize.classify.constantize.unscoped.order(
					'id asc').collect(&:attributes)

#				file.write data.inject({}) { |hash, record|
#					record.delete('created_at')
#					record.delete('updated_at')
#					#	so that it is really string sortable, add leading zeros
#					hash["#{table_name}_#{sprintf('%03d',record['id'])}"] = record
#					hash
#				}.to_ordered_yaml


				file.write recursive_hash_to_yml_string(
					data.inject({}) { |hash, record|
						record.delete('created_at')
						record.delete('updated_at')
						#	so that it is really string sortable, add leading zeros
						hash["#{table_name}_#{sprintf('%03d',record['id'])}"] = record
						hash
					}
				)

			end
		end
		exit	#	REQUIRED OR WILL ATTEMPT TO PROCESS ARGUMENTS AS RAKE TASK
	end

	desc "Dump MYSQL table descriptions."
	task :describe => :environment do
		puts
		puts "FYI: This task ONLY works on MYSQL databases."
		puts
		config = ActiveRecord::Base.connection.instance_variable_get(:@config)
#=> {:adapter=>"mysql", :host=>"localhost", :password=>nil, :username=>"root", :database=>"my_development", :encoding=>"utf8"}

#		tables = ActiveRecord::Base.connection.execute('show tables;')
#		while( table = tables.fetch_row ) do
#	changes for MySQL2
		tables = ActiveRecord::Base.connection.execute('show tables;').to_a.flatten.sort
		while( table = tables.shift ) do
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



	desc "Calculate row size"
	task :row_sizes => :environment do
		puts
		puts "FYI: This task ONLY works on MYSQL databases."
		puts
		config = ActiveRecord::Base.connection.instance_variable_get(:@config)
		#=> {:adapter=>"mysql", :host=>"localhost", :password=>nil, 
		#		:username=>"root", :database=>"my_development", :encoding=>"utf8"}

		tables = ActiveRecord::Base.connection.execute('show tables;').to_a.flatten.sort
		require 'nokogiri'

		while( table = tables.shift ) do
#		begin
#			table = tables.first
			puts "Table: #{table}"

			#	may have to include host and port
			command = "mysql -X " <<
				"--user=#{config[:username]} " <<
				"--password='#{config[:password]}' " <<
				"--execute='describe #{table}' " <<
				config[:database]

#			puts command
			xml_doc = Nokogiri::XML(`#{command}`)

			#  <row>
			#	<field name="Field">id</field>
			#	<field name="Type">int(11)</field>
			#	<field name="Null">NO</field>
			#	<field name="Key">PRI</field>
			#	<field name="Default" xsi:nil="true" />
			#	<field name="Extra">auto_increment</field>
			#  </row>
			table_size = 0
			#	http://www.w3schools.com/xpath/xpath_syntax.asp
			xml_doc.xpath("//row/field[@name='Type']").each do |field|
				field_size = case field.text
					when /tinyint/ then 1
					when /smallint/ then 2
					when /mediumint/ then 3
					when /bigint/ then 8
					when /int/ then 4			#	or integer (match last as would match above)
					when /double/ then 4
					when /float/ then 4
					when /datetime/ then 8
					when /timestamp/ then 4
					when /year/ then 1
					when /date/ then 3
					when /time/ then 3
					when /varchar\(\d+\)/ then field.text.scan(/varchar\((\d+)\)/).first.first.to_i
					else 100	#	just a guess
#						puts field
				end
#				puts "#{field.name} - #{field.text} - #{field_size}"
				table_size += field_size
			end
			puts table_size
		end

	end

end	#	namespace :db do
end	#	namespace :app do





#	Would have to be very careful here as to not break anything.
#	I don't know when to quote, add a | or a |- (or what the diff is)


#Possible yaml sort.  Doesn't use the yaml library 

#http://stackoverflow.com/questions/7275952/how-can-i-sort-yaml-files
#	(modified)


#	This WILL NOT WORK when the hash contains values that contains multi-line
#	strings (like a text area).  Somehow things need quoted or | or |- added.

#	needed for escape
require 'yaml'

#	doesn't exist in ruby 1.9.3,
#	but seems ok with it being commented out.
#	probably included in yaml.rb
#require 'yaml/encoding'	

def recursive_hash_to_yml_string(hash, depth=0)
	yml_string = ''
	spacer = ""
	depth.times { spacer += "  "}
	hash.keys.sort.each do |sorted_key|
		yml_string += spacer + sorted_key + ": "
		if hash[sorted_key].is_a?(Hash)
			yml_string += "\n"
			yml_string += recursive_hash_to_yml_string(hash[sorted_key], depth+1)
		else
			s = hash[sorted_key].to_s
			if s.match("\n")
				yml_string += "|-\n"
				s.split(/\n/).each do |line|
					yml_string += "#{spacer}  #{line}\n"
				end
			else
#	YAML.escape doesn't actually seem to escape as I would expect
#				yml_string += "#{s.gsub(/([:>])/,"\\1")}\n"
#				yml_string += "\"#{s}\"\n"

				if s.match(/:/)
					yml_string += "\"#{s}\"\n"
				else
					yml_string += "#{s}\n"
				end
			end
		end
	end
	yml_string
end

