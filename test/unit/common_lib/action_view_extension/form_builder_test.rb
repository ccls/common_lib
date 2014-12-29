require 'test_helper'

class CommonLib::ActionViewExtension::FormBuilderTest < ActionView::TestCase

	#	needed to include field_wrapper
	include CommonLib::ActionViewExtension::Base

#	rails 3.2.8 now html_escapes ' to &#x27; in these input selectors
#	rails 4 now html_escapes ' to &#39;
#	rails 4.2.0 now uses Nokogiri which doesn't escape

	test "sex_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| f.sex_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_string_field', :count => 1 do
				assert_select 'option', :value => 'M', :text => 'male', :count => 1
				assert_select 'option', :value => 'F', :text => 'female', :count => 1
				assert_select 'option', :value => 'DK', :text => "don't know", :count => 1
			end
		end
	end

	test "wrapped_sex_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| f.wrapped_sex_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.sex_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'select#form_model_string_field', :count => 1 do
					assert_select 'option', :value => 'M', :text => 'male', :count => 1
					assert_select 'option', :value => 'F', :text => 'female', :count => 1
					assert_select 'option', :value => 'DK', :text => "don't know", :count => 1
				end
			end
		end
	end

	test "datetime_text_field" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.datetime_text_field(:datetime_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'input.datetimepicker#form_model_datetime_field', :count => 1
		end
	end

	test "datetime_text_field with value" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.datetime_text_field(:datetime_field, :value => 'sometestvalue' ) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'input.datetimepicker#form_model_datetime_field', 
				:value => 'sometestvalue', :count => 1
		end
	end

	test "wrapped_datetime_text_field" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_datetime_text_field(:datetime_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.datetime_field.datetime_text_field.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Datetime field', :count => 1
				assert_select 'input.datetimepicker#form_model_datetime_field', 
					:value => '', :count => 1
			end
		end
	end

	test "date_text_field" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.date_text_field(:date_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'input.datepicker#form_model_date_field', :count => 1
		end
	end

	test "date_text_field with value" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.date_text_field(:date_field, :value => 'sometestvalue') })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'input.datepicker#form_model_date_field', 
				:value => 'sometestvalue', :count => 1
		end
	end

	test "wrapped_date_text_field" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_date_text_field(:date_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.date_field.date_text_field.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Date field', :count => 1
				assert_select 'input.datepicker#form_model_date_field', 
					:value => '', :count => 1
			end
		end
	end

	#	This isn't in an 'erb block' so it isn't really testing what I wanted.
	test "wrapped_date_text_field with block" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_date_text_field(:date_field){
					'testing'
				} })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.date_field.date_text_field.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Date field', :count => 1
				assert_select 'input.datepicker#form_model_date_field', 
					:value => 'testing', :count => 1
			end
		end
	end

	test "meridiem_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.meridiem_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
				assert_select 'select#form_model_string_field', :count => 1 do
					assert_select 'option', :value => '', :text => 'Meridiem', :count => 1
					assert_select 'option', :value => 'AM', :text => 'AM', :count => 1
					assert_select 'option', :value => 'PM', :text => 'PM', :count => 1
			end
		end
	end

	test "wrapped_meridiem_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_meridiem_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.meridiem_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'select#form_model_string_field', :count => 1 do
					assert_select 'option', :value => '', :text => 'Meridiem', :count => 1
					assert_select 'option', :value => 'AM', :text => 'AM', :count => 1
					assert_select 'option', :value => 'PM', :text => 'PM', :count => 1
				end
			end
		end
	end

	test "minute_select" do
		response = Nokogiri::HTML::DocumentFragment.parse( 
			form_for(FormModel.new,:url => '/'){|f| 
				f.minute_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_string_field', :count => 1 do
				assert_select 'option', :value => '', :text => 'Minute', :count => 1
				(0..59).each do |min|
					assert_select 'option', :value => min, :text => sprintf('%02d',min), :count => 1
				end
			end
		end
	end

	test "wrapped_minute_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_minute_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.minute_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'select#form_model_string_field', :count => 1 do
					assert_select 'option', :value => '', :text => 'Minute', :count => 1
					(0..59).each do |min|
						assert_select 'option', :value => min, 
							:text => sprintf('%02d',min), :count => 1
					end
				end
			end
		end
	end

	test "hour_select" do
		response = Nokogiri::HTML::DocumentFragment.parse( 
			form_for(FormModel.new,:url => '/'){|f| 
				f.hour_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_string_field', :count => 1 do
				assert_select 'option', :value => '', :text => 'Hour', :count => 1
				(1..12).each do |hr|
					assert_select 'option', :value => hr, :text => hr.to_s, :count => 1
				end
			end
		end
	end

	test "wrapped_hour_select" do
		response = Nokogiri::HTML::DocumentFragment.parse( 
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_hour_select(:string_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.hour_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'select#form_model_string_field', :count => 1 do
					assert_select 'option', :value => '', :text => 'Hour', :count => 1
					(1..12).each do |hr|
						assert_select 'option', :value => hr, :text => hr.to_s, :count => 1
					end
				end
			end
		end
	end

	test "wrapped_text_field with post_text" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_text_field(:string_field, :post_text => "I'm after" ) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.text_field.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'input#form_model_string_field', 
					:value => '', :count => 1
				assert_select 'span', :text => "I'm after", :count => 1
			end
		end
	end

	test "wrapped_text_field with block with wrapped_text_field" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_text_field(:string_field){
					f.wrapped_text_field(:integer_field)
				} })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.text_field.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'input#form_model_string_field', 
					:value => '', :count => 1
				assert_select 'div.integer_field.text_field.field_wrapper', :count => 1 do
					assert_select 'label.label', :text => 'Integer field', :count => 1
					assert_select 'input#form_model_integer_field', 
						:value => '', :count => 1
				end
			end
		end
	end

	test "wrapped_check_box with a block and post_text" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_check_box(:string_field, :post_text => "I'm after" ){
					f.wrapped_text_field(:integer_field)
				} })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.check_box.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'input#form_model_string_field[type=checkbox]', 
					:value => '1', :count => 1
				assert_select 'div.integer_field.text_field.field_wrapper', :count => 1 do
					assert_select 'label.label', :text => 'Integer field', :count => 1
					assert_select 'input#form_model_integer_field', 
						:value => '', :count => 1
				end
				assert_select 'span', :text => "I'm after", :count => 1
			end
		end
	end

	test "wrapped_check_box with post_text" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_check_box(:string_field, :post_text => "I'm after" ) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.string_field.check_box.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'String field', :count => 1
				assert_select 'input#form_model_string_field[type=checkbox]', 
					:value => '1', :count => 1
				assert_select 'span', :text => "I'm after", :count => 1
			end
		end
	end



	test "some missing method" do
		assert_raises(NoMethodError) {
			form_for(FormModel.new,:url => '/'){|f| 
				f.this_method_does_not_exist }
		}
	end


	test "yndk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.yndk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value => 1, :text => 'Yes', :count => 1
				assert_select 'option', :value => 2, :text => 'No', :count => 1
				assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
			end
		end
	end

	test "wrapped_yndk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_yndk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.yndk_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value => 1, :text => 'Yes', :count => 1
					assert_select 'option', :value => 2, :text => 'No', :count => 1
					assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
				end
			end
		end
	end


	test "ynrdk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.ynrdk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value => 1, :text => 'Yes', :count => 1
				assert_select 'option', :value => 2, :text => 'No', :count => 1
				assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
				assert_select 'option', :value => 888, :text => 'Refused', :count => 1
			end
		end
	end

	test "wrapped_ynrdk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_ynrdk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.ynrdk_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value=>1, :text => 'Yes', :count => 1
					assert_select 'option', :value=>2, :text => 'No', :count => 1
					assert_select 'option', :value=>999, :text => "Don't Know", :count => 1
					assert_select 'option', :value=>888, :text => 'Refused', :count => 1
				end
			end
		end
	end

	test "ynodk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.ynodk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value=>1, :text => 'Yes', :count => 1
				assert_select 'option', :value=>2, :text => 'No', :count => 1
				assert_select 'option', :value=>3, :text => 'Other', :count => 1
				assert_select 'option', :value=>999, :text => "Don't Know", :count => 1
			end
		end
	end

	test "wrapped_ynodk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_ynodk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.ynodk_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value=>1, :text => 'Yes', :count => 1
					assert_select 'option', :value=>2, :text => 'No', :count => 1
					assert_select 'option', :value=>3, :text => 'Other', :count => 1
					assert_select 'option', :value=>999, :text => "Don't Know", :count => 1
				end
			end
		end
	end

	test "ynordk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.ynordk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value=>1, :text => 'Yes', :count => 1
				assert_select 'option', :value=>2, :text => 'No', :count => 1
				assert_select 'option', :value=>3, :text => 'Other', :count => 1
				assert_select 'option', :value=>999, :text => "Don't Know", :count => 1
				assert_select 'option', :value=>888, :text => 'Refused', :count => 1
			end
		end
	end

	test "wrapped_ynordk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_ynordk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.ynordk_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value => 1, :text => 'Yes', :count => 1
					assert_select 'option', :value => 2, :text => 'No', :count => 1
					assert_select 'option', :value => 3, :text => 'Other', :count => 1
					assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
					assert_select 'option', :value => 888, :text => 'Refused', :count => 1
				end
			end
		end
	end

	test "padk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.padk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value => 1, :text => 'Present', :count => 1
				assert_select 'option', :value => 2, :text => 'Absent', :count => 1
				assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
			end
		end
	end

	test "adna_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.adna_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'select#form_model_integer_field', :count => 1 do
				assert_select 'option', :value => 1, :text => 'Agree', :count => 1
				assert_select 'option', :value => 2, :text => 'Do Not Agree', :count => 1
				assert_select 'option', :value => 555, :text => 'N/A', :count => 1
				assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
			end
		end
	end

	test "wrapped_padk_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_padk_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.padk_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value => 1, :text => 'Present', :count => 1
					assert_select 'option', :value => 2, :text => 'Absent', :count => 1
					assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
				end
			end
		end
	end

	test "wrapped_adna_select" do
		response = Nokogiri::HTML::DocumentFragment.parse(
			form_for(FormModel.new,:url => '/'){|f| 
				f.wrapped_adna_select(:integer_field) })	#	.root
		assert_select response, 'form.new_form_model', :count => 1 do
			assert_select 'div.integer_field.adna_select.field_wrapper', :count => 1 do
				assert_select 'label.label', :text => 'Integer field', :count => 1
				assert_select 'select#form_model_integer_field', :count => 1 do
					assert_select 'option', :value => 1, :text => 'Agree', :count => 1
					assert_select 'option', :value => 2, :text => 'Do Not Agree', :count => 1
					assert_select 'option', :value => 555, :text => 'N/A', :count => 1
					assert_select 'option', :value => 999, :text => "Don't Know", :count => 1
				end
			end
		end
	end

end	#	class FormBuilderHelperTest < ActionView::TestCase
