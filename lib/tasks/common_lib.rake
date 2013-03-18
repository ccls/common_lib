#puts "Just loaded common_lib rake file.  Woohoo!"

namespace :common_lib do
	desc "don't do anything"
	task :nothing => :environment do

		puts "Not doing anything"

	end
end
