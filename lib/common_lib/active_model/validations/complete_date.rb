#	don't think that this is necessary here, but ...
require 'active_support/core_ext/object/blank'

#
#	This is just a modified version of validates_presence_of
#
#	I think that this validation inherently is allow_blank => true
#

module ActiveModel

	# == Active Model Complete Date Validator
	module Validations
		class CompleteDateValidator < EachValidator
			def validate(record)
				[attributes].flatten.each do |attribute|
					value = record.send("#{attribute}_before_type_cast")
					if( value.is_a?(String) and !value.blank? )
						date_hash = Date._parse(value)
						#	>> Date._parse( '1/10/2011')
						#	=> {:mon=>1, :year=>2011, :mday=>10}
						unless date_hash.has_key?(:year) &&
								date_hash.has_key?(:mon) &&
								date_hash.has_key?(:mday)
							#	associated default error message is in config/locales/en.yml
							record.errors.add(attribute, :incomplete_date, options)
						end
					end
				end
			end

#			def validate(record)
#				[attributes].flatten.each do |attribute|
#
##
##	This doesn't work correctly for DateTimes
##
##	Apparently, DateTimes are immediately typecast.
##	It either is valid or isn't.  PERIOD.
##
##	I can raise an error that the given datetime was incomplete,
##	but when it is re-presented to the user, it will be complete.
##
##	for datetime
##BEFORE TC:03/2012
##AFTER TC:2012-03-01 00:00:00 -0800
##
##	for date
##BEFORE TC:03/2012
##AFTER TC:
#
##	partial datetimes will actually have the attribute set to a full datetime
##		with the defaults of 0s or 1s filled in.
##	partial dates will NOT.  Why the difference?  ERRRRRR
##
##	for both, however, the text field in view will correctly retain the 
##		before_type_cast partial input?  Yay, I guess.  Confused, definitely.
##	
#
#
##	my fake attributes don't have _before_type_cast, because that's what they are
#
#
#
##					value = record.send(:read_attribute_for_validation, attribute)
#					#	I really want the before_type_cast
#					value = record.send("#{attribute}_before_type_cast")
#
#
#
##					value = if record.methods.include?("#{attribute}_before_type_cast")
##						record.send("#{attribute}_before_type_cast")
##					else
##						record.send("#{attribute}")
##					end
#
#
##
##	shouldn't the allow_nil and allow_blank features actually
##	be dealt with already? actually no, that's in the add method
##		but we can't get that far as will fail if nil
##
##					unless( options[:allow_nil] && value.nil? ) ||
##						( options[:allow_blank] && value.blank? ) ||
##						( !value.is_a?(String) )
#
#
##					unless( !value.is_a?(String) )
#					if( value.is_a?(String) and !valid.blank? )
#						date_hash = Date._parse(value)
#						#	>> Date._parse( '1/10/2011')
#						#	=> {:mon=>1, :year=>2011, :mday=>10}
#						unless date_hash.has_key?(:year) &&
#							date_hash.has_key?(:mon) &&
#							date_hash.has_key?(:mday)
#							#	associated default error message is in config/locales/en.yml
#							record.errors.add(attribute, :incomplete_date, options)
#						end
#					end
#				end
#			end
		end


		module HelperMethods
			# Validates that the specified attributes contain a complete date. Happens by default on save. Example:
			#
			#	 class Person < ActiveRecord::Base
			#		 validates_complete_date_for :dob
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
			def validates_complete_date_for(*attr_names)
				validates_with CompleteDateValidator, _merge_attributes(attr_names)
			end
		end
	end
end
