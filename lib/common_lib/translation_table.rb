class CommonLib::TranslationTable

	def self.[](key=nil)
		short(key) || short(key.to_s.downcase) || value(key) || nil
	end

#	DO NOT MEMORIZE HERE.  IT ENDS UP IN ALL SUBCLASSES
#	Doesn't really seem necessary.  It isn't that complicated.

	#	[1,2,999]
	def self.valid_values
#		@@valid_values ||= table.collect{ |x| x[:value] }
		table.collect{ |x| x[:value] }
	end

	#	[['Yes',1],['No',2],["Don't Know",999]]
	def self.selector_options
#		@@selector_options ||= table.collect{|x| [x[:long],x[:value]] }
		table.collect{|x| [x[:long],x[:value]] }
	end

protected

	def self.short(key)
		index = table.find_index{|x| x[:short] == key.to_s }
		( index.nil? ) ? nil : table[index][:value]
	end

	def self.value(key)
#	used in testing and breaks in ruby 1.9.3 so next line is NEEDED!
return nil if key == :nil
		index = table.find_index{|x| x[:value] == key.to_i }
		( index.nil? ) ? nil : table[index][:long] 
	end

	def self.table
		[]
	end
end


class YNDK < CommonLib::TranslationTable
	#	unique translation table
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes', :long => "Yes" },
			{ :value => 2,   :short => 'no',  :long => "No" },
			{ :value => 999, :short => 'dk',  :long => "Don't Know" }
		]
	end
end
#
#	YNDK[1]     => 'Yes'
#	YNDK['1']   => 'Yes'
#	YNDK['yes'] => 1
#	YNDK[:yes]  => 1
#	YNDK[:asdf] => nil
#
#	YNDK[:Yes] => 1
#	YNDK[:YES] => 1
#
#	YNDK[:nil] => ????	# worked in ruby 1.8.7, errors in 1.9.3
#		:nil.to_i => NoMethodError: undefined method `to_i' for :nil:Symbol
#		what did it do?  was that correct?
#
#	in jruby 
#	jruby-1.5.1 :003 > :nil.to_i
#	 => 610 
#	which, in hind site, makes some sort of sense, but is NOT what is wanted
#	same in ruby 1.8.7 (basically object id)
#
class YNODK < CommonLib::TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes',   :long => "Yes" },
			{ :value => 2,   :short => 'no',    :long => "No" },
			{ :value => 3,   :short => 'other', :long => "Other" },
			{ :value => 999, :short => 'dk',    :long => "Don't Know" }
		]
	end
end
class YNRDK < CommonLib::TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes',     :long => "Yes" },
			{ :value => 2,   :short => 'no',      :long => "No" },
			{ :value => 999, :short => 'dk',      :long => "Don't Know" },
			{ :value => 888, :short => 'refused', :long => "Refused" }
		]
	end
end
class YNORDK < CommonLib::TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'yes',     :long => "Yes" },
			{ :value => 2,   :short => 'no',      :long => "No" },
			{ :value => 3,   :short => 'other',   :long => "Other" },
			{ :value => 999, :short => 'dk',      :long => "Don't Know" },
			{ :value => 888, :short => 'refused', :long => "Refused" }
		]
	end
end
class ADNA < CommonLib::TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'agree',    :long => "Agree" },
			{ :value => 2,   :short => 'disagree', :long => "Do Not Agree" },
			{ :value => 555, :short => 'na',       :long => "N/A" },
			{ :value => 999, :short => 'dk',       :long => "Don't Know" }
		]
	end
end
class PADK < CommonLib::TranslationTable
	def self.table
		@@table ||= [
			{ :value => 1,   :short => 'present', :long => "Present" },
			{ :value => 2,   :short => 'absent',  :long => "Absent" },
			{ :value => 999, :short => 'dk',      :long => "Don't Know" }
		]
	end
end
#class POSNEG < CommonLib::TranslationTable
#	def self.table
#		@@table ||= [
#			{ :value => 1,   :short => 'pos', :long => "Positive" },
#			{ :value => 2,   :short => 'neg', :long => "Negative" }
#		]
#	end
#end
