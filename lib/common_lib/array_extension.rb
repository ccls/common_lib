module CommonLib	#	:nodoc:
module ArrayExtension	#	:nodoc:
	def self.included(base)
#		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

#	module ClassMethods	#	:nodoc:
#	end

	module InstanceMethods

		#	['a','b','c'].arrange([2,0,1]) => ['c','a','b']
		def arrange(new_array_index=[])
			new_array = self.dup
			new_array_index.each_with_index do |index,new_index|
				new_array[new_index] = self[index]
			end
			new_array
		end 

		#	Remove all "blank?" items for the array
		def drop_blanks!
			delete_if{|a|a.blank?}
		end

		#	Return capitlized versions of each item in the array
		def capitalize
			collect(&:capitalize)
		end

		#	Capitalize each item in the array and return it
		def capitalize!
			each_with_index do |element,index|
				self[index] = element.capitalize
			end
			self
		end

		#	Return downcased versions of each item in the array
		def downcase
			collect(&:downcase)
		end

		#	Return the average digitized value of the array
		def average
			if self.length > 0
				#	sum defined in activesupport/lib/active_support/core_ext/enumerable.rb
				self.digitize.sum.to_f / self.length
			else
				nil
			end
		end

		#	Return the median digitized value of the array
		def median
			if self.length > 0
				sorted_values = self.digitize.sort
				length = sorted_values.length
				if length.odd?
					sorted_values[length/2]
				else
					( sorted_values[length/2] + sorted_values[-1+length/2] ).to_f / 2
				end
			else
				nil
			end
		end

		#	Return a copy of the array with values at the
		#	given indexes swapped.
		def swap_indexes(i,j)
			new_array = self.dup
			new_array[i],new_array[j] = self[j],self[i]
			new_array
		end

		#	Swap the values of an array at the given indexes
		#	and return it
		def swap_indexes!(i,j)
			self[i],self[j] = self[j],self[i]
			self
		end

		#	Convert all items in the array to_f
		def numericize
			collect(&:to_f)
		end
		alias_method :digitize, :numericize

#		def first_index(value = nil)	#	either way works

		#	return the first index of the array
		#	with a value matching that given
		def first_index(value = nil, &block)
			using_block = block_given?
			each_with_index do |element,index|
				return index if (using_block && yield(element)) || (value == element)
			end
			return nil
		end

		def to_boolean
			!empty? && all?{|v| v.to_boolean }
		end
#		alias_method :true?, :to_boolean
		alias_method :to_b,  :to_boolean

		#	[].true? 
		#	=> false
		#	[true].true? 
		#	=> true
		#	[true,false].true? 
		#	=> true
		#	[false].true? 
		#	=> false
		def true?
			!empty? && any?{|v| v.true? }
		end

		def false?
			!empty? && any?{|v| v.false? }
		end

		#	I need to work on this one ...
		def true_xor_false?
#			self.include?('true') ^ self.include?('false') ^
#				self.include?(true) ^ self.include?(false)
			contains_true = contains_false = false
			each {|v|
#				( v.to_boolean ) ? contains_true = true : contains_false = true
				eval("contains_#{v.to_boolean}=true")
			}
			contains_true ^ contains_false
		end

	end
end
end
Array.send(:include, CommonLib::ArrayExtension)
