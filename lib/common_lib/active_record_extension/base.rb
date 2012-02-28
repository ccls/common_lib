module CommonLib::ActiveRecordExtension::Base
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def random
			count = count()
			if count > 0
				first(:offset => rand(count))
			else
				nil
			end
		end

		def validates_absence_of(*attr_names)
			configuration = { :on => :save,
				:message => "is present and must be absent." }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|
					unless record.send(attr_name).blank?
						record.errors.add(attr_name, 
							ActiveRecord::Error.new(record,attr_name,:present,
								{ :message => configuration[:message] }))
					end
				end
			end
		end

		def validates_past_date_for(*attr_names)
			configuration = { :on => :save,
				:allow_today => true,
				:message => "is in the future and must be in the past." }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|
					#	ensure that it is a date and not datetime
					#	in some tests, this is actually set to a datetime (5.years.ago), and need a date for comparison
					#	in some tests, it is nil, so need a try
					date = record.send(attr_name).try(:to_date)

#	When tests run late at night, this fails because of timezones I imagine.
#	However, using Date.today as opposed to Time.now seems to work.
#	Don't know why I ever used Time.now.  Probably because the incoming date could be a datetime.
#	May need to actually call to_date on the incoming 'date' just to be sure.
#	This is just wrong.  Logically, one would expect it to be true, but is not most likely due to time zone conversion.
#	>> Time.now < Date.tomorrow
#	=> false
#	This does work, however, but Time.now.to_date seems to be the same as Date.today
#	>> Time.now.to_date < Date.tomorrow
#	=> true
#
#	>> Time.now
#	=> Fri Dec 02 22:57:34 -0800 2011
#	>> Date.today
#	=> Fri, 02 Dec 2011
#	>> Time.now < Date.yesterday
#	=> false
#	>> Time.now < Date.tomorrow
#	=> false
#	>> Time.now < Date.today
#	=> false
#	>> Date.today < Date.yesterday
#	=> false
#	>> Date.today < Date.tomorrow
#	=> true
#	>> Date.today < Date.today
#	=> false
#					if !date.blank? && Time.now < date


					base_date = if configuration[:allow_today]
						Date.today
					else
						Date.yesterday
					end
#	actually, this allows today by default
#					if !date.blank? && Date.today < date
					if !date.blank? && base_date < date
						record.errors.add(attr_name, 
							ActiveRecord::Error.new(record,attr_name,:not_past_date,
								{ :message => configuration[:message] }))
					end
				end
			end
		end

		#	This doesn't work as one would expect if the column
		#	is a DateTime instead of just a Date.
		#	For some reason, *_before_type_cast actually
		#	returns a parsed DateTime?
		def validates_complete_date_for(*attr_names)
			configuration = { :on => :save,
				:message => "is not a complete date." }
			configuration.update(attr_names.extract_options!)

			send(validation_method(configuration[:on]), configuration) do |record|
				attr_names.each do |attr_name|

					value = record.send("#{attr_name}_before_type_cast")
					unless( configuration[:allow_nil] && value.blank? ) ||
						( !value.is_a?(String) )
						date_hash = Date._parse(value)
						#	>> Date._parse( '1/10/2011')
						#	=> {:mon=>1, :year=>2011, :mday=>10}
						unless date_hash.has_key?(:year) &&
							date_hash.has_key?(:mon) &&
							date_hash.has_key?(:mday)
							record.errors.add(attr_name, 
								ActiveRecord::Error.new(record,attr_name,:not_complete_date,
									{ :message => configuration[:message] }))
						end
					end
				end
			end
		end

	end

end	#	module CommonLib::ActiveRecordExtension::Base
ActiveRecord::Base.send(:include,
	CommonLib::ActiveRecordExtension::Base)
