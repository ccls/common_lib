class ActiveRecord::Base

	#
	#	I have found that the validations are really cluttering up the models.
	#	Moving them into a yml file and pulling them in like so seems to 
	#	be working well.
	#
	#	Not all validations are going to work, but so far so good.
	#	
	#	http://codereview.stackexchange.com/questions/159/use-of-a-regex-stored-inside-yaml-file
	#		email_regex: !ruby/regexp /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
	#	http://stackoverflow.com/questions/3337020/how-to-specify-ranges-in-yaml
	#		:in: !ruby/range 5..250
	#	http://www.opensource.apple.com/source/ruby/ruby-14/ruby/lib/yaml/rubytypes.rb
	#	http://yaml4r.sourceforge.net/doc/page/objects_in_yaml.htm
	#
	def self.validations_from_yaml_file
		validation_file = File.join(Rails.root,"config/validations/#{self.to_s.underscore}.yml")
		if File.exists?(validation_file)
			h = YAML::load( ERB.new( IO.read( validation_file )).result)

			#	if the yml file is empty, h is false ( added "if h" condition )
			h.each do |validation|
				attributes=[validation.delete(:attributes), validation.delete(:attribute)
					].compact.flatten
				self.validates *attributes, validation
			end if h
#		else
#			puts "YAML validations file not found so not using."
		end
	end

	def self.validates_uniqueness_of_with_nilification(*args)
		#	NOTE ANY field that has a unique index in the database NEEDS
		#	to NOT be blank.  Multiple nils are acceptable in index, 
		#	but multiple blanks are NOT.  Nilify ALL fields with
		#	unique indexes in the database. At least those that
		#	would appear on a form, as an empty text box is sent
		#	as '' and not nil, hence the initial problem.
		#	The first one will work, but will fail after.

		#	ONLY IF THE FIELD IS A STRING!
		class_eval do
			validates_uniqueness_of args, :allow_blank => true
			args.each do |arg|
				before_validation {
					self.send("#{arg}=", nil) if self.send(arg).blank?
				}
			end
		end
	end

	def self.nilify_if_blank(*args)
		#	ONLY IF THE FIELD IS A STRING!
		class_eval do
			args.each do |arg|
				before_save {
					self.send("#{arg}=", nil) if self.send(arg).blank?
				}
			end
		end
	end

	def self.acts_like_a_hash(*args)
		options = {
			:key   => :key,
			:value => :description
		}.update(args.extract_options!)

		#	I guess we must explicitly remember the options
		#	so that can reference the 'key' in []
#		@@acts_like_a_hash_options = options
#		@@acts_like_a_hash_memory  = {}
#
#	Using @@ seems to share the variable in ActiveRecord::Base
#	Using cattr_accessor seems to share it in the subclass
#
		cattr_accessor :acts_like_a_hash_options
		cattr_accessor :acts_like_a_hash_memory

		class_eval do

			self.acts_like_a_hash_options = options
			self.acts_like_a_hash_memory = {}
	
			validates_presence_of   options[:key], options[:value]
			validates_uniqueness_of options[:key], options[:value]
			validates_length_of     options[:key], options[:value],
				:maximum => 250, :allow_blank => true

			# Treats the class a bit like a Hash and
			# searches for a record with a matching key.
			def self.[](key)
				self.acts_like_a_hash_memory[key.downcase.to_s] ||=
					where(self.arel_table[self.acts_like_a_hash_options[:key]].matches(key)).first
			end

#NameError: undefined local variable or method `options' for #<Class:0x107229540>
#class << self
#			define_method "[]" do |key|
#				where(options[:key] => key.to_s)
#			end
#end

		end	#	class_eval do
	end	#	def acts_like_a_hash(*args)

	def self.random
		count = count()
		if count > 0
			offset(rand(count)).limit(1).first
		else
			nil
		end
	end


	cattr_accessor :aliased_attributes
	def self.alias_attribute_with_memory(new_name, old_name)
		self.aliased_attributes ||= {}.with_indifferent_access
		self.aliased_attributes[new_name] = old_name
		alias_attribute_without_memory(new_name, old_name)
	end
	class << self
		alias_method_chain :alias_attribute, :memory
	end

end	#	class ActiveRecord::Base
