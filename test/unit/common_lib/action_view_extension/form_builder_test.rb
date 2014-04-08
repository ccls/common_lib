require 'test_helper'

class CommonLib::ActionViewExtension::FormBuilderTest < ActionView::TestCase

	#	needed to include field_wrapper
	include CommonLib::ActionViewExtension::Base

#	rails 3.2.8 now html_escapes ' to &#x27; in these input selectors
#	rails 4 now html_escapes ' to &#39;

	test "sex_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.sex_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_string_field" name="form_model[string_field]"><option value="">-select-</option>
<option value="M">male</option>
<option value="F">female</option>
<option value="DK">don&#39;t know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_sex_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_sex_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field sex_select field_wrapper'>
<label for="form_model_string_field">String field</label><select id="form_model_string_field" name="form_model[string_field]"><option value="">-select-</option>
<option value="M">male</option>
<option value="F">female</option>
<option value="DK">don&#39;t know</option></select>
</div><!-- class='string_field sex_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "datetime_text_field" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.datetime_text_field(:datetime_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><input class="datetimepicker" id="form_model_datetime_field" name="form_model[datetime_field]" type="text" /></form>}
		assert_equal expected, output_buffer
	end

	test "datetime_text_field with value" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.datetime_text_field(:datetime_field, :value => 'sometestvalue' ) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><input class="datetimepicker" id="form_model_datetime_field" name="form_model[datetime_field]" type="text" value="sometestvalue" /></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_datetime_text_field" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_datetime_text_field(:datetime_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='datetime_field datetime_text_field field_wrapper'>
<label for="form_model_datetime_field">Datetime field</label><input class="datetimepicker" id="form_model_datetime_field" name="form_model[datetime_field]" type="text" />
</div><!-- class='datetime_field datetime_text_field' --></form>}
		assert_equal expected, output_buffer
	end

	test "date_text_field" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.date_text_field(:date_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><input class="datepicker" id="form_model_date_field" name="form_model[date_field]" type="text" /></form>}
		assert_equal expected, output_buffer
	end

	test "date_text_field with value" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.date_text_field(:date_field, :value => 'sometestvalue') }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><input class="datepicker" id="form_model_date_field" name="form_model[date_field]" type="text" value="sometestvalue" /></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_date_text_field" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_date_text_field(:date_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='date_field date_text_field field_wrapper'>
<label for="form_model_date_field">Date field</label><input class="datepicker" id="form_model_date_field" name="form_model[date_field]" type="text" />
</div><!-- class='date_field date_text_field' --></form>}
		assert_equal expected, output_buffer
	end

	#	This isn't in an 'erb block' so it isn't really testing what I wanted.
	test "wrapped_date_text_field with block" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_date_text_field(:date_field){
				'testing'
			} }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='date_field date_text_field field_wrapper'>
<label for="form_model_date_field">Date field</label><input class="datepicker" id="form_model_date_field" name="form_model[date_field]" type="text" />testing
</div><!-- class='date_field date_text_field' --></form>}
		assert_equal expected, output_buffer
	end

	test "meridiem_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.meridiem_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_string_field" name="form_model[string_field]"><option value="">Meridiem</option>
<option value="AM">AM</option>
<option value="PM">PM</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_meridiem_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_meridiem_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field meridiem_select field_wrapper'>
<label for="form_model_string_field">String field</label><select id="form_model_string_field" name="form_model[string_field]"><option value="">Meridiem</option>
<option value="AM">AM</option>
<option value="PM">PM</option></select>
</div><!-- class='string_field meridiem_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "minute_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.minute_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_string_field" name="form_model[string_field]"><option value="">Minute</option>\n<option value="0">00</option>\n<option value="1">01</option>\n<option value="2">02</option>\n<option value="3">03</option>\n<option value="4">04</option>\n<option value="5">05</option>\n<option value="6">06</option>\n<option value="7">07</option>\n<option value="8">08</option>\n<option value="9">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_minute_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_minute_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field minute_select field_wrapper'>\n<label for="form_model_string_field">String field</label><select id="form_model_string_field" name="form_model[string_field]"><option value="">Minute</option>\n<option value="0">00</option>\n<option value="1">01</option>\n<option value="2">02</option>\n<option value="3">03</option>\n<option value="4">04</option>\n<option value="5">05</option>\n<option value="6">06</option>\n<option value="7">07</option>\n<option value="8">08</option>\n<option value="9">09</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option>\n<option value="13">13</option>\n<option value="14">14</option>\n<option value="15">15</option>\n<option value="16">16</option>\n<option value="17">17</option>\n<option value="18">18</option>\n<option value="19">19</option>\n<option value="20">20</option>\n<option value="21">21</option>\n<option value="22">22</option>\n<option value="23">23</option>\n<option value="24">24</option>\n<option value="25">25</option>\n<option value="26">26</option>\n<option value="27">27</option>\n<option value="28">28</option>\n<option value="29">29</option>\n<option value="30">30</option>\n<option value="31">31</option>\n<option value="32">32</option>\n<option value="33">33</option>\n<option value="34">34</option>\n<option value="35">35</option>\n<option value="36">36</option>\n<option value="37">37</option>\n<option value="38">38</option>\n<option value="39">39</option>\n<option value="40">40</option>\n<option value="41">41</option>\n<option value="42">42</option>\n<option value="43">43</option>\n<option value="44">44</option>\n<option value="45">45</option>\n<option value="46">46</option>\n<option value="47">47</option>\n<option value="48">48</option>\n<option value="49">49</option>\n<option value="50">50</option>\n<option value="51">51</option>\n<option value="52">52</option>\n<option value="53">53</option>\n<option value="54">54</option>\n<option value="55">55</option>\n<option value="56">56</option>\n<option value="57">57</option>\n<option value="58">58</option>\n<option value="59">59</option></select>\n</div><!-- class='string_field minute_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "hour_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.hour_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_string_field" name="form_model[string_field]"><option value="">Hour</option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_hour_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_hour_select(:string_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field hour_select field_wrapper'>\n<label for="form_model_string_field">String field</label><select id="form_model_string_field" name="form_model[string_field]"><option value="">Hour</option>\n<option value="1">1</option>\n<option value="2">2</option>\n<option value="3">3</option>\n<option value="4">4</option>\n<option value="5">5</option>\n<option value="6">6</option>\n<option value="7">7</option>\n<option value="8">8</option>\n<option value="9">9</option>\n<option value="10">10</option>\n<option value="11">11</option>\n<option value="12">12</option></select>\n</div><!-- class='string_field hour_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_text_field with post_text" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_text_field(:string_field, :post_text => "I'm after" ) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field text_field field_wrapper'>
<label for="form_model_string_field">String field</label><input id="form_model_string_field" name="form_model[string_field]" type="text" /><span>I'm after</span>
</div><!-- class='string_field text_field' --></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_text_field with block with wrapped_text_field" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_text_field(:string_field){
				f.wrapped_text_field(:integer_field)
			} }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field text_field field_wrapper'>
<label for="form_model_string_field">String field</label><input id="form_model_string_field" name="form_model[string_field]" type="text" /><div class='integer_field text_field field_wrapper'>
<label for="form_model_integer_field">Integer field</label><input id="form_model_integer_field" name="form_model[integer_field]" type="text" />
</div><!-- class='integer_field text_field' -->
</div><!-- class='string_field text_field' --></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_check_box with a block and post_text" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_check_box(:string_field, :post_text => "I'm after" ){
				f.wrapped_text_field(:integer_field)
			} }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field check_box field_wrapper'>
<input name="form_model[string_field]" type="hidden" value="0" /><input id="form_model_string_field" name="form_model[string_field]" type="checkbox" value="1" /><label for="form_model_string_field">String field</label><div class='integer_field text_field field_wrapper'>
<label for="form_model_integer_field">Integer field</label><input id="form_model_integer_field" name="form_model[integer_field]" type="text" />
</div><!-- class='integer_field text_field' --><span>I'm after</span>
</div><!-- class='string_field check_box' --></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_check_box with post_text" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| 
			f.wrapped_check_box(:string_field, :post_text => "I'm after" ) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='string_field check_box field_wrapper'>
<input name="form_model[string_field]" type="hidden" value="0" /><input id="form_model_string_field" name="form_model[string_field]" type="checkbox" value="1" /><label for="form_model_string_field">String field</label><span>I'm after</span>
</div><!-- class='string_field check_box' --></form>}
		assert_equal expected, output_buffer
	end



	test "some missing method" do
		assert_raises(NoMethodError) {
			form_for(FormModel.new,:url => '/'){|f| 
				f.this_method_does_not_exist }
		}
	end


	test "yndk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.yndk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don&#39;t Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_yndk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_yndk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field yndk_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don&#39;t Know</option></select>
</div><!-- class='integer_field yndk_select' --></form>}
		assert_equal expected, output_buffer
	end


	test "ynrdk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.ynrdk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don&#39;t Know</option>
<option value="888">Refused</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_ynrdk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_ynrdk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field ynrdk_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don&#39;t Know</option>
<option value="888">Refused</option></select>
</div><!-- class='integer_field ynrdk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "ynodk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.ynodk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don&#39;t Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_ynodk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_ynodk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field ynodk_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don&#39;t Know</option></select>
</div><!-- class='integer_field ynodk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "ynordk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.ynordk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don&#39;t Know</option>
<option value="888">Refused</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_ynordk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_ynordk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field ynordk_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don&#39;t Know</option>
<option value="888">Refused</option></select>
</div><!-- class='integer_field ynordk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "padk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.padk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Present</option>
<option value="2">Absent</option>
<option value="999">Don&#39;t Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "adna_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.adna_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="555">N/A</option>
<option value="999">Don&#39;t Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_padk_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_padk_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field padk_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Present</option>
<option value="2">Absent</option>
<option value="999">Don&#39;t Know</option></select>
</div><!-- class='integer_field padk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_adna_select" do
		output_buffer = form_for(FormModel.new,:url => '/'){|f| f.wrapped_adna_select(:integer_field) }
		expected = %{<form accept-charset="UTF-8" action="/" class="new_form_model" id="new_form_model" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /></div><div class='integer_field adna_select field_wrapper'>
<label for="form_model_integer_field">Integer field</label><select id="form_model_integer_field" name="form_model[integer_field]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="555">N/A</option>
<option value="999">Don&#39;t Know</option></select>
</div><!-- class='integer_field adna_select' --></form>}
		assert_equal expected, output_buffer
	end

end	#	class FormBuilderHelperTest < ActionView::TestCase
