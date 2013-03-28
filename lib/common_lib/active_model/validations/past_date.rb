#	don't think that this is necessary here, but ...
require 'active_support/core_ext/object/blank'

#
#	This is just a modified version of validates_presence_of
#
#	I think that this validation inherently is allow_blank => true
#

module ActiveModel

	# == Active Model Past Date Validator
	module Validations
		class PastDateValidator < EachValidator
			def validate(record)
				[attributes].flatten.each do |attribute|
#					value = record.send(attribute)
					value = record.send(:read_attribute_for_validation, attribute)

					allow_today = ( options.has_key?(:allow_today) ) ? options[:allow_today] : true

					base_date = if value.is_a?(ActiveSupport::TimeWithZone)
#						puts "Comparing #{attribute} as ActiveSupport::TimeWithZone"
						( allow_today ) ? Time.zone.now : ( Time.zone.now - 1.day )
					elsif value.is_a?(DateTime)
#						puts "Comparing #{attribute} as DateTime"
						( allow_today ) ? Time.now : ( Time.now - 1.day )
					else
#						puts "Comparing #{attribute} as Date"
#						( allow_today ) ? Date.today : Date.yesterday
						( allow_today ) ? Date.current : Date.yesterday
					end
					if !value.blank? && value > base_date
						#	associated default error message is in config/locales/en.yml
						record.errors.add(attribute, :future_date, options)
					end
				end
			end

#			def validate(record)
#				[attributes].flatten.each do |attribute|
##					value = record.send(attribute)
#					value = record.send(:read_attribute_for_validation, attribute)
#
##
##	Do this differenly for Dates and DateTimes?
##	How to know what it is when the value is blank?
##
#					allow_today = ( options.has_key?(:allow_today) ) ? options[:allow_today] : true
#
#					base_date = if value.is_a?(ActiveSupport::TimeWithZone)
##puts "Comparing as ActiveSupport::TimeWithZone"
#						( allow_today ) ? Time.zone.now : ( Time.zone.now - 1.day )
#					elsif value.is_a?(DateTime)
##puts "Comparing as DateTime"
#						( allow_today ) ? Time.now : ( Time.now - 1.day )
#					else
##puts "Comparing as Date"
#						( allow_today ) ? Date.today : Date.yesterday
#					end
##	usually dates
##Sample @@ should allow collected_at to be today: Comparing as Date
##Comparing as Date
##Comparing as Date
##Comparing as Date
##Comparing as ActiveSupport::TimeWithZone
##Comparing as Date
##Comparing as Date
##Comparing as Date
##Comparing as Date
##Comparing as Date
#
#
##
##	if base_date is a date and value is a DateTime
##	ArgumentError: comparison of Date with ActiveSupport::TimeWithZone failed
##
#
##					if !value.blank? && base_date < value
#					if !value.blank? && value > base_date
##						record.errors.add(attribute, "is in the future and must be in the past.", options)
#						#	associated default error message is in config/locales/en.yml
#						record.errors.add(attribute, :future_date, options)
#					end
#				end
#			end
		end

		module HelperMethods
			# Validates that the specified attributes contain a date in the past. Happens by default on save. Example:
			#
			#	 class Person < ActiveRecord::Base
			#		 validates_past_date_for :dob
			#	 end
			#
			# The first_name attribute must be in the object and it cannot be blank.
			#
			# If you want to validate the absence of a boolean field (where the real values are true and false),
			# you will want to use <tt>validates_inclusion_of :field_name, :in => [true, false]</tt>.
			#
			# This is due to the way Object#blank? handles boolean values: <tt>false.blank? # => true</tt>.
			#
			# Configuration options:
			# * <tt>:message</tt> - A custom error message (default is: "can't be blank").
			# * <tt>:on</tt> - Specifies when this validation is active. Runs in all
			#	 validation contexts by default (+nil+), other options are <tt>:create</tt>
			#	 and <tt>:update</tt>.
			# * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
			#	 occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).
			#	 The method, proc or string should return or evaluate to a true or false value.
			# * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
			#	 not occur (e.g. <tt>:unless => :skip_validation</tt>, or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>).
			#	 The method, proc or string should return or evaluate to a true or false value.
			# * <tt>:strict</tt> - Specifies whether validation should be strict. 
			#	 See <tt>ActiveModel::Validation#validates!</tt> for more information
			#
			def validates_past_date_for(*attr_names)
				validates_with PastDateValidator, _merge_attributes(attr_names)
			end
		end
	end
end
