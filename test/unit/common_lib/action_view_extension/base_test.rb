require 'test_helper'

class CommonLib::User
	attr_accessor :yes_or_no, :yndk, :dob, :sex, :name, :dob_before_type_cast
	def initialize(*args,&block)
		yield self if block_given?
	end
	def yes_or_no?
		!!yes_or_no
	end
end

class CommonLib::ActionViewExtension::BaseTest < ActionView::TestCase

	setup :enable_content_for_usage
	def enable_content_for_usage
#
# the following raises NoMethodError: undefined method `append' for nil:NilClass ????
# I really don't understand.  I use content_for in other places just like this?
# Actually, the other tests may be failing before the content_for call
#
# what is nil? This works in reality, but not in testing
# wouldn't be surprised if this is controller related.
#
#   in rails 3, there is something called "@view_flow"
# 
# adding '_prepare_context' before the call fixes the nil, but then there's another error
#
# NoMethodError: undefined method `encoding_aware?' for nil:NilClass
#    test/unit/helpers/action_view_base_helper_test.rb:340:in `new'
#
# don't use @content_for_head anymore.  Just use content_for(:head)
#

#	Is this the best way?  Doubt it, but it works.

		_prepare_context	#	need this to set @view_flow so content_for works
	end



	def flash
		{:notice => "Hello There"}
	end
#	delegate :flash, :to => :controller


#	required

	test "required(text) should" do
		response = HTML::Document.new(required('something')).root
		#"<span class='required'>something</span>"
		assert_select response, 'span.required', :text => 'something', :count => 1
	end

#	req

	test "req(text) should" do
		response = HTML::Document.new(req('something')).root
		#"<span class='required'>something</span>"
		assert_select response, 'span.required', :text => 'something', :count => 1
	end

#	mdy

	test "mdy(nil) should return nbsp" do
		response = mdy(nil)
		assert_equal '&nbsp;', response
	end

	test "mdy(some valid date) should return mdy of date" do
		response = mdy(Date.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy(some valid datetime) should return mdy of date" do
		response = mdy(DateTime.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy(some valid time) should return mdy of date" do
		response = mdy(Time.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy('blah, blah, blah') should return nbsp" do
		response = mdy('blah, blah, blah')
		assert_equal '&nbsp;', response
	end

#	mdy_or_nil

	test "mdy_or_nil(nil) should return nil" do
		response = mdy_or_nil(nil)
		assert_nil response
	end

	test "mdy_or_nil(some valid date) should return mdy of date" do
		response = mdy_or_nil(Date.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy_or_nil(some valid datetime) should return mdy of date" do
		response = mdy_or_nil(DateTime.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy_or_nil(some valid time) should return mdy of date" do
		response = mdy_or_nil(Time.parse('Dec 31, 1999'))
		assert_equal '12/31/1999', response
	end

	test "mdy_or_nil('blah, blah, blah') should return nil" do
		response = mdy_or_nil('blah, blah, blah')
		assert_nil response
	end


#	mdyhm

	test "mdyhm(nil) should return nbsp" do
		response = mdyhm(nil)
		assert_equal '&nbsp;', response
	end

	test "mdyhm(some valid date) should return mdy of date" do
		response = mdyhm(Date.parse('Dec 31, 1999'))
		assert_equal '12/31/1999 00:00 (+00:00)', response
	end

	test "mdyhm(some valid datetime) should return mdy of date" do
		response = mdyhm(DateTime.parse('Dec 31, 1999'))
		assert_equal '12/31/1999 00:00 (+00:00)', response
	end

	test "mdyhm(some valid time) should return mdy of date" do
		response = mdyhm(Time.parse('Dec 31, 1999 00:00:00 -0000'))
		#	Time zone will reflect the CURRENT timezone (PDT or PST) which changes 
		#	obviously so explicitly specifying one so test always works.
		#	using +0000 will result in coversion to local zone (PST or PDT)
		#	using -0000 will result in UTC (should anyway)
		assert_equal '12/31/1999 00:00 (UTC)', response
	end

	test "mdyhm('blah, blah, blah') should return nbsp" do
		response = mdyhm('blah, blah, blah')
		assert_equal '&nbsp;', response
	end

#	mdyhm_or_nil

	test "mdyhm_or_nil(nil) should return nbsp" do
		response = mdyhm_or_nil(nil)
		assert_nil response
	end

	test "mdyhm_or_nil(some valid date) should return mdy of date" do
		response = mdyhm_or_nil(Date.parse('Dec 31, 1999'))
		assert_equal '12/31/1999 00:00 (+00:00)', response
	end

	test "mdyhm_or_nil(some valid datetime) should return mdy of date" do
		response = mdyhm_or_nil(DateTime.parse('Dec 31, 1999'))
		assert_equal '12/31/1999 00:00 (+00:00)', response
	end

	test "mdyhm_or_nil(some valid time) should return mdy of date" do
		response = mdyhm(Time.parse('Dec 31, 1999 00:00:00 -0000'))
		#	Time zone will reflect the CURRENT timezone (PDT or PST) which changes 
		#	obviously so explicitly specifying one so test always works.
		#	using +0000 will result in coversion to local zone (PST or PDT)
		#	using -0000 will result in UTC (should anyway)
		assert_equal '12/31/1999 00:00 (UTC)', response
	end

	test "mdyhm_or_nil('blah, blah, blah') should return nbsp" do
		response = mdyhm_or_nil('blah, blah, blah')
		assert_nil response
	end


#	time_mdy

	#	apparently not used anywhere anymore.
	#	could remove the method or test it manually in order to get 100%
	test "time_mdy(nil) should return nbsp" do
		response = time_mdy(nil)
		assert_equal '&nbsp;', response
	end

	test "time_mdy(some valid time) should return formated time" do
		response = time_mdy(Time.parse('Dec 24, 1999 11:59 pm'))
		assert_equal "11:59 PM 12/24/1999", response
	end

	test "time_mdy('blah, blah, blah') should return nbsp" do
		response = time_mdy('blah, blah, blah')
		assert_equal '&nbsp;', response
	end


#	field_wrapper

	test "field_wrapper" do
		response = HTML::Document.new(
			field_wrapper('mymethod') do
				'Yield'
			end).root
#<div class="mymethod field_wrapper">
#Yield
#</div><!-- class='mymethod' -->
		assert_select response, 'div.mymethod.field_wrapper'
	end


#	_wrapped_spans

	test "wrapped_spans without options" do
		@user = CommonLib::User.new
		response = HTML::Document.new(
			wrapped_spans(:user, :name)).root
#<div class="name field_wrapper">
#<span class="label">name</span>
#<span class="value">&nbsp;</span>
#</div><!-- class='name' -->
		assert_select response, 'div.name.field_wrapper', :count => 1 do
			assert_select 'label', :count => 0
			assert_select 'span.label', :count => 1
			assert_select 'span.value', :count => 1
		end
	end

	test "wrapped_spans with post text" do
		@user = CommonLib::User.new
		response = HTML::Document.new(
			wrapped_spans(:user, :name, :post_text => 'blah')).root
		assert_select response, 'div.name.field_wrapper', :count => 1 do
			assert_select 'label', :count => 0
			assert_select 'span.label', :count => 1
			assert_select 'span.value', :count => 1
			assert_select 'span.post_text', :count => 1, :text => 'blah'
		end
	end

#	_wrapped_date_spans

	test "wrapped_date_spans blank" do
		@user = CommonLib::User.new
		response = HTML::Document.new(
			wrapped_date_spans(:user, :dob)).root
#<div class="dob date_spans field_wrapper">
#<span class="label">dob</span>
#<span class="value">&nbsp;</span>
#</div><!-- class='dob date_spans' -->
		assert_select response, 'div.dob.date_spans.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'dob',:count => 1
			assert_select 'span.value',:text => '&nbsp;',:count => 1
		end
	end

	test "wrapped_date_spans Dec 5, 1971" do
		@user = CommonLib::User.new{|u| u.dob = Date.parse('Dec 5, 1971')}
		response = HTML::Document.new(
			wrapped_date_spans(:user, :dob)).root
#<div class="dob date_spans field_wrapper">
#<span class="label">dob</span>
#<span class="value">12/05/1971</span>
#</div><!-- class='dob date_spans' -->
		assert_select response, 'div.dob.date_spans.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'dob',:count => 1
			assert_select 'span.value',:text => '12/05/1971',:count => 1
		end
	end

	test "wrapped_date_spans Dec 5, 1971 with post text" do
		@user = CommonLib::User.new{|u| u.dob = Date.parse('Dec 5, 1971')}
		response = HTML::Document.new(
			wrapped_date_spans(:user, :dob, :post_text => 'happy bday')).root
		assert_select response, 'div.dob.date_spans.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'dob',:count => 1
			assert_select 'span.value',:text => '12/05/1971',:count => 1
			assert_select 'span.post_text',:text => 'happy bday',:count => 1
		end
	end


#	_wrapped_datetime_spans

	test "wrapped_datetime_spans blank" do
		@user = CommonLib::User.new
		response = HTML::Document.new(
			wrapped_datetime_spans(:user, :dob)).root
		assert_select response, 'div.dob.datetime_spans.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'dob',:count => 1
			assert_select 'span.value',:text => '&nbsp;',:count => 1
		end
	end

	test "wrapped_datetime_spans Dec 5, 1971" do
		@user = CommonLib::User.new{|u| u.dob = Date.parse('Dec 5, 1971')}
		response = HTML::Document.new(
			wrapped_datetime_spans(:user, :dob)).root
		assert_select response, 'div.dob.datetime_spans.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'dob',:count => 1
			assert_select 'span.value',:text => '12/05/1971 00:00 (+00:00)',:count => 1
		end
	end




#	_wrapped_yes_or_no_spans

	test "wrapped_yes_or_no_spans blank" do
		@user = CommonLib::User.new
		response = HTML::Document.new(
			wrapped_yes_or_no_spans(:user, :yes_or_no)).root
#<div class="yes_or_no field_wrapper">
#<span class="label">yes_or_no</span>
#<span class="value">no</span>
#</div><!-- class='yes_or_no' -->
		assert_select response, 'div.yes_or_no.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'yes_or_no',:count => 1
			assert_select 'span.value',:text => 'No',:count => 1
		end
	end

	test "wrapped_yes_or_no_spans true" do
		@user = CommonLib::User.new{|u| u.yes_or_no = true }
		response = HTML::Document.new(
			wrapped_yes_or_no_spans(:user, :yes_or_no)).root
#<div class="yes_or_no field_wrapper">
#<span class="label">yes_or_no</span>
#<span class="value">yes</span>
#</div><!-- class='yes_or_no' -->
		assert_select response, 'div.yes_or_no.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'yes_or_no',:count => 1
			assert_select 'span.value',:text => 'Yes',:count => 1
		end
	end

	test "wrapped_yes_or_no_spans false" do
		@user = CommonLib::User.new(:yes_or_no => false)
		response = HTML::Document.new(
			wrapped_yes_or_no_spans(:user, :yes_or_no)).root
#<div class="yes_or_no field_wrapper">
#<span class="label">yes_or_no</span>
#<span class="value">no</span>
#</div><!-- class='yes_or_no' -->
		assert_select response, 'div.yes_or_no.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'yes_or_no',:count => 1
			assert_select 'span.value',:text => 'No',:count => 1
		end
	end

	test "wrapped_yes_or_no_spans false with post text" do
		@user = CommonLib::User.new(:yes_or_no => false)
		response = HTML::Document.new(
			wrapped_yes_or_no_spans(:user, :yes_or_no, :post_text => 'blah')).root
		assert_select response, 'div.yes_or_no.field_wrapper' do
			assert_select 'label', :count => 0
			assert_select 'span.label',:text => 'yes_or_no',:count => 1
			assert_select 'span.value',:text => 'No',:count => 1
			assert_select 'span.post_text',:text => 'blah',:count => 1
		end
	end



#	method_missing_with_wrapping



#	form_link_to

	test "form_link_to with block" do
		response = HTML::Document.new(
			form_link_to('mytitle','/myurl') do
				hidden_field_tag('apple','orange')
			end).root
#<form class='form_link_to' action='/myurl' method='post'>
#<input id="apple" name="apple" type="hidden" value="orange" />
#<input type="submit" value="mytitle" />
#</form>
		assert_select response, 'form.form_link_to[action=/myurl]', :count => 1 do
			assert_select 'input', :count => 3
		end
	end

	test "form_link_to without block" do
		response = HTML::Document.new(form_link_to('mytitle','/myurl')).root
		assert_select response, 'form.form_link_to[action=/myurl]', :count => 1 do
			assert_select 'input', :count => 2
		end
#<form class="form_link_to" action="/myurl" method="post">
#<input type="submit" value="mytitle" />
#</form>
	end

#	destroy_link_to


	test "destroy_link_to with block" do
		response = HTML::Document.new(
			destroy_link_to('mytitle','/myurl') do
				hidden_field_tag('apple','orange')
			end).root
#<form class="destroy_link_to" action="/myurl" method="post">
#<div style="margin:0;padding:0;display:inline"><input name="_method" type="hidden" value="delete" /></div>
#<input id="apple" name="apple" type="hidden" value="orange" /><input type="submit" value="mytitle" />
#</form>
		assert_select response, 'form.destroy_link_to[action=/myurl]', :count => 1 do
			assert_select 'div', :count => 1 do
				assert_select 'input[name=_method][value=delete]',:count => 1
			end
			assert_select 'input', :count => 4
		end
	end

	test "destroy_link_to without block" do
		response = HTML::Document.new(destroy_link_to('mytitle','/myurl')).root
#<form class="destroy_link_to" action="/myurl" method="post">
#<div style="margin:0;padding:0;display:inline"><input name="_method" type="hidden" value="delete" /></div>
#<input type="submit" value="mytitle" />
#</form>
		assert_select response, 'form.destroy_link_to[action=/myurl]', :count => 1 do
			assert_select 'div', :count => 1 do
				assert_select 'input[name=_method][value=delete]',:count => 1
			end
			assert_select 'input', :count => 3
		end
	end



#	aws_image_tag
#	must use ::RAILS_APP_NAME to ensure proper namespace

	test "aws_image_tag with RAILS_APP_NAME set" do
		::RAILS_APP_NAME = bucket = 'yadayada'
		response = HTML::Document.new( aws_image_tag('myimage')).root
		#<img alt="myimage" src="http://s3.amazonaws.com/ccls/images/myimage" />
		assert_select response, "img[src=http://s3.amazonaws.com/#{bucket}/images/myimage]", :count => 1
		#	otherwise it sticks around
		Object.send(:remove_const,:RAILS_APP_NAME)
	end

	test "aws_image_tag without RAILS_APP_NAME set" do
		response = HTML::Document.new( aws_image_tag('myimage')).root
		assert !defined?(::RAILS_APP_NAME), "RAILS_APP_NAME is set?" # :#{Object.const_get(:RAILS_APP_NAME)}:"
		bucket = 'commonlib'
		assert_equal bucket, Rails.application.class.parent.to_s.downcase
		#<img alt="myimage" src="http://s3.amazonaws.com/ccls/images/myimage" />
		assert_select response, "img[src=http://s3.amazonaws.com/#{bucket}/images/myimage]", :count => 1
	end


#	flasher

	test "flasher" do
		response = HTML::Document.new(
			flasher
		).root
#<p class="flash" id="notice">Hello There</p>
#<noscript>
#<p id="noscript" class="flash">Javascript is required for this site to be fully functional.</p>
#</noscript>
		assert_select response, 'p#notice.flash'
		assert_select response, 'noscript' do
			assert_select 'p#noscript.flash'
		end
	end


#	stylesheets

	test "stylesheets" do
		assert_nil @stylesheets
		stylesheets('mystylesheet')
		assert @stylesheets.include?('mystylesheet')
		assert_equal 1, @stylesheets.length
		stylesheets('mystylesheet')
		assert_equal 1, @stylesheets.length
#<link href="/stylesheets/mystylesheet.css" media="screen" rel="stylesheet" type="text/css" />
		response = HTML::Document.new( content_for(:head) ).root
		assert_select response, 'link[href=/stylesheets/mystylesheet.css]'
	end


#	javascripts

	test "javascripts" do
		assert_nil @javascripts
		javascripts('myjavascript')
		assert @javascripts.include?('myjavascript')
		assert_equal 1, @javascripts.length
		javascripts('myjavascript')
		assert_equal 1, @javascripts.length
#<script src="/javascripts/myjavascript.js" type="text/javascript"></script>
		response = HTML::Document.new( content_for(:head) ).root
		assert_select response, 'script[src=/javascripts/myjavascript.js]'
	end

end
