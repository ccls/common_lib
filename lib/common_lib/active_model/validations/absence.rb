#	don't think that this is necessary here, but ...
require 'active_support/core_ext/object/blank'

#
#	This is just a modified version of validates_presence_of
#

module ActiveModel

	# == Active Model Absence Validator
	module Validations
		class AbsenceValidator < EachValidator

			def validate(record)
				[attributes].flatten.each do |attribute|
					value = record.send(:read_attribute_for_validation, attribute)
					#	associated default error message is in config/locales/en.yml
					record.errors.add(attribute, :absent, options) unless value.blank?
				end
			end

#			def validate(record)
#				[attributes].flatten.each do |attribute|
#					value = record.send(:read_attribute_for_validation, attribute)
#
##	same thing since :read_attribute_for_validation is an alias for :send
##	which is technically record.send(:send,attribute) which is the same as ...
#
#
##	TODO
##	custom validation messages don't seem to be making it through.
##	i think I need to add something in the locales and pass a symbol that finds the default.
##	Still not sure
#
#
##					value = record.send(attribute)
##					record.errors.add(attribute, "is present and must be absent.", options) unless value.blank?
#					#	associated default error message is in config/locales/en.yml
#					record.errors.add(attribute, :absent, options) unless value.blank?
#				end
#			end

		end

		module HelperMethods
			# Validates that the specified attributes are  blank (as defined by Object#blank?). Happens by default on save. Example:
			#
			#	 class Person < ActiveRecord::Base
			#		 validates_absence_of :first_name
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
			def validates_absence_of(*attr_names)
				validates_with AbsenceValidator, _merge_attributes(attr_names)
			end
		end
	end
end
