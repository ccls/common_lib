require 'test_helper'

class SomeModel
	extend ActiveModel::Naming
	attr_accessor :some_attribute
	attr_accessor :some_attribute_before_type_cast #	for date_text_field
	def to_key; end
end

#	needed to include field_wrapper
#module CommonLib::ActionViewExtension; end
require 'common_lib/action_view_extension'
#require 'common_lib/action_view_extension/base'
#require 'common_lib/action_view_extension/form_builder'

class CommonLib::ActionViewExtension::FormBuilderTest < ActionView::TestCase
#class CommonLibFormHelperTest < ActionView::TestCase

	#	needed to include field_wrapper
	include CommonLib::ActionViewExtension::Base
	include CommonLib::ActionViewExtension::FormBuilder
#	include CommonLib::ActionView
#	include CommonLibHelper

	test "date_text_field" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.date_text_field(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><input class="datepicker" id="some_model_some_attribute" name="some_model[some_attribute]" size="30" type="text" /></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_date_text_field" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_date_text_field(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='some_attribute date_text_field field_wrapper'>\n<label for="some_model_some_attribute">Some attribute</label><input class="datepicker" id="some_model_some_attribute" name="some_model[some_attribute]" size="30" type="text" />\n</div><!-- class='some_attribute date_text_field' --></form>}
		assert_equal expected, output_buffer
	end

	#	This isn't in an 'erb block' so it isn't really testing what I wanted.
	test "wrapped_date_text_field with block" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_date_text_field(:some_attribute){
				'testing'
			} }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='some_attribute date_text_field field_wrapper'>\n<label for="some_model_some_attribute">Some attribute</label><input class="datepicker" id="some_model_some_attribute" name="some_model[some_attribute]" size="30" type="text" />testing\n</div><!-- class='some_attribute date_text_field' --></form>}
		assert_equal expected, output_buffer
	end

	test "meridiem_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.meridiem_select(:some_attribute) }
		expected = %{<form accept-charset=\"UTF-8\" action=\"/\" class=\"new_some_model\" id=\"new_some_model\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /></div><select id=\"some_model_some_attribute\" name=\"some_model[some_attribute]\"><option value=\"\">Meridiem</option>\n<option value=\"AM\">AM</option>\n<option value=\"PM\">PM</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_meridiem_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_meridiem_select(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='some_attribute meridiem_select field_wrapper'>\n<label for="some_model_some_attribute">Some attribute</label><select id="some_model_some_attribute" name="some_model[some_attribute]"><option value="">Meridiem</option>\n<option value="AM">AM</option>\n<option value="PM">PM</option></select>\n</div><!-- class='some_attribute meridiem_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "minute_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.minute_select(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="some_model_some_attribute" name="some_model[some_attribute]"><option value="">Minute</option>\n<option value="0">00</option>\n<option value="1">01</option>\n<option value="2">02</option>\n<option value="3">03</option>\n<option value="4">04</option>\n<option value="5">05</option>\n<option value="6">06</option>\n<option value="7">07</option>\n<option value="8">08</option>\n<option value="9">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_minute_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_minute_select(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='some_attribute minute_select field_wrapper'>\n<label for="some_model_some_attribute">Some attribute</label><select id="some_model_some_attribute" name="some_model[some_attribute]"><option value="">Minute</option>\n<option value="0">00</option>\n<option value="1">01</option>\n<option value="2">02</option>\n<option value="3">03</option>\n<option value="4">04</option>\n<option value="5">05</option>\n<option value="6">06</option>\n<option value="7">07</option>\n<option value="8">08</option>\n<option value="9">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option></select>\n</div><!-- class='some_attribute minute_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "hour_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.hour_select(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="some_model_some_attribute" name="some_model[some_attribute]"><option value="">Hour</option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_hour_select" do
		output_buffer = form_for(SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_hour_select(:some_attribute) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_some_model" id="new_some_model" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='some_attribute hour_select field_wrapper'>\n<label for="some_model_some_attribute">Some attribute</label><select id="some_model_some_attribute" name="some_model[some_attribute]"><option value="">Hour</option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option></select>\n</div><!-- class='some_attribute hour_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "some missing method" do
		assert_raises(NoMethodError) {
			form_for(SomeModel.new,:url => '/'){|f| 
				concat f.this_method_does_not_exist }
		}
	end

end
