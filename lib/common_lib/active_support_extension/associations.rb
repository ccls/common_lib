module CommonLib::ActiveSupportExtension::Associations

	def self.included(base)
		base.extend ClassMethods
		base.class_eval do 
			class << self
				alias_methods = {
					:should_have_many                  => :should_have_many_,
					:should_have_many_associations     => :should_have_many_
				}
				alias_methods.each do |alias_name,method_name|
					alias_method( "assert_#{alias_name}",
						"assert_#{method_name}" ) unless
							self.method_defined?("assert_#{alias_name}")
				end # alias_methods.each
			end # class << self
		end # base.class_eval
	end # def self.included

	module ClassMethods

		def assert_should_initially_belong_to(*associations)
			options = associations.extract_options!
			model = options[:model] || model_name_without_test
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize
				title = "#{brand}should initially belong to #{assoc}"
				if !options[:class_name].blank?
					title << " ( #{options[:class_name]} )"
					class_name = options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_not_nil object.send(assoc)
					if object.send(assoc).respond_to?(
						"#{model.underscore.pluralize}_count")
						assert_equal 1, object.reload.send(assoc).send(
							"#{model.underscore.pluralize}_count")
					end
					if !options[:class_name].blank?
						assert object.send(assoc).is_a?(class_name.constantize)
					end
				end
			end
		end

		def assert_should_belong_to(*associations)
			options = associations.extract_options!
			model = options[:model] || model_name_without_test
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize
				title = "#{brand}should belong to #{assoc}" 
				if !options[:class_name].blank?
					title << " ( #{options[:class_name]} )"
					class_name = options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_nil object.send(assoc)
					object.send("#{assoc}=",send("create_#{class_name.underscore}"))
					assert_not_nil object.send(assoc)
					assert object.send(assoc).is_a?(class_name.constantize
						) unless options[:polymorphic]
#	Paperclip attachments don't get deleted on rollback.
#	So we much destroy the object, and therefore the attachment, by hand.
#	Only seems to matter with ...
#		BirthDatumTest#assert_should_belong_to( :birth_datum_update )
#		but does't seem to cause a problem elsewhere.
object.send(assoc).destroy
object.destroy
				end
			end
		end

		def assert_should_have_one(*associations)
			options = associations.extract_options!
			model = options[:model] || model_name_without_test
			associations.each do |assoc|
				assoc = assoc.to_s
				test "#{brand}should have one #{assoc}" do
					object = create_object
					assert_nil object.reload.send(assoc)
					send("create_#{assoc}", model.underscore => object )
					assert_not_nil object.reload.send(assoc)
					object.send(assoc).destroy
					assert_nil object.reload.send(assoc)
				end
			end
		end

		def assert_should_have_many_(*associations)
			options = associations.extract_options!
			model = options[:model] || model_name_without_test
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize
				title = "#{brand}should have many #{assoc}"
				if !options[:class_name].blank?
					title << " ( #{options[:class_name]} )"
					class_name = options[:class_name].to_s
				end
				if !options[:as].blank?
					title << " ( as #{options[:as]} )"
				end
				test title do
					object = create_object
					assert_equal 0, object.send(assoc).length
					command = ["create_#{class_name.singularize.underscore}"]
					if !options[:foreign_key].blank?
						command.push( options[:foreign_key].to_sym => object.id )
					elsif !options[:as].blank?
						command.push( options[:as].to_sym => object )
					else
						command.push( model.underscore => object )
					end
					send *command
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					send *command
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end
			end
		end

		def assert_should_habtm(*associations)
			options = associations.extract_options!
			model = options[:model] || model_name_without_test
			associations.each do |assoc|
				assoc = assoc.to_s
				test "#{brand}should habtm #{assoc}" do
					object = create_object
					assert_equal 0, object.send(assoc).length
					object.send(assoc) << send("create_#{assoc.singularize}")
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					object.send(assoc) << send("create_#{assoc.singularize}")
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end
			end
		end

	end	# ClassMethods

end	# module ActiveSupportExtension::Associations
ActiveSupport::TestCase.send(:include, CommonLib::ActiveSupportExtension::Associations)
