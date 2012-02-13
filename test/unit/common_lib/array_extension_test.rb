require 'test_helper'

class CommonLib::ArrayExtensionTest < ActiveSupport::TestCase

#		def arrange(new_array_index=[])
#		def drop_blanks!
#		def capitalize
#		def capitalize!
#		def downcase
#		def average
#		def median
#		def swap_indexes(i,j)
#		def swap_indexes!(i,j)
#		def numericize
#		def first_index(value = nil, &block)
#		def to_boolean
#		def true?
#		def false?
#		def true_xor_false?

	test "should arrange array" do
		assert_equal ["c", "a", "b"], ['a','b','c'].arrange([2,0,1])
	end

	test "should drop empty strings from array" do
		x = [0,1,'zero','one','']
		y = x.drop_blanks!
		assert_equal [0,1,'zero','one'], x
		assert_equal [0,1,'zero','one'], y
	end

	test "should drop nils from array" do
		x = [0,1,'zero','one',nil]
		y = x.drop_blanks!
		assert_equal [0,1,'zero','one'], x
		assert_equal [0,1,'zero','one'], y
	end

	test "should capitalize! all strings in existing array" do
		x = ['foo','bar']
		y = x.capitalize!
		assert_equal ['Foo','Bar'], x
		assert_equal ['Foo','Bar'], y
	end

	test "should capitalize all strings in new array" do
		x = ['foo','bar']
		y = x.capitalize
		assert_equal ['foo','bar'], x		#	no change to original
		assert_equal ['Foo','Bar'], y
	end

	test "should downcase all strings in new array" do
		x = ['FOO','BAR']
		y = x.downcase
		assert_equal ['FOO','BAR'], x		#	no change to original
		assert_equal ['foo','bar'], y
	end

	test "should numericize/digitize" do
		x = ['foo', 'bar', 0, '42', '-0.4', nil]
		y = x.numericize
		assert_equal ['foo', 'bar', 0, '42', '-0.4', nil], x
		assert_equal [0.0, 0.0, 0.0, 42, -0.4, 0.0], y
	end

	test "should compute sum" do
		x = ['foo', 'bar', 0, '42', '-0.4', nil]
		y = x.numericize.sum
		assert_equal ['foo', 'bar', 0, '42', '-0.4', nil], x
		assert_equal 41.6, y
	end

	test "should compute average" do
		x = [ 1, 1, 4 ]
		y = x.average
		assert_equal 2.0, y
	end

	test "should compute average of empty array" do
		x = []
		y = x.average
		assert_nil y
	end

	test "should compute median of odd length array" do
		x = [ 1, 1, 4 ]
		y = x.median
		assert_equal 1, y
	end

	test "should compute median of even length array" do
		x = [ 1, 1, 3, 4 ]
		y = x.median
		assert_equal 2, y
	end

	test "should compute median of empty array" do
		x = []
		y = x.median
		assert_nil y
	end

	test "should swap values based on indexes" do
		x = %w( apple banana orange )
		y = x.swap_indexes(0,2)
		assert_equal %w( apple banana orange ), x
		assert_equal %w( orange banana apple ), y
	end

	test "should swap! values based on indexes" do
		x = %w( apple banana orange )
		y = x.swap_indexes!(0,2)
		assert_equal %w( orange banana apple ), x
		assert_equal %w( orange banana apple ), y
	end

	test "should find first index via argument" do
		x = %w( apple banana orange )
		assert_equal 1, x.first_index('banana')
	end

	test "should find first index via block" do
		x = %w( apple banana orange )
		assert_equal 1, x.first_index{|i| i == 'banana'}
	end

	test "should return nil for first index with empty array" do
		assert_nil [].first_index('banana')
	end

	test "should return nil for first index with no match" do
		x = %w( apple banana orange )
		assert_nil x.first_index('pineapple')
	end


	#	to_boolean / to_b / true? / false?
	test "should be true with all true" do
		assert [true, 'true', 1, '1', 't'].to_boolean
		assert [true, 'true', 1, '1', 't'].to_b

		assert  [true, 'true', 1, '1', 't'].true?
		assert ![true, 'true', 1, '1', 't'].false?
	end

	test "should be false with one false" do
		assert ![true, 'true', 1, '1', 't', 'f'].to_boolean
		assert ![true, 'true', 1, '1', 't', 'f'].to_b

		assert [true, 'true', 1, '1', 't', 'f'].true?
		assert [true, 'true', 1, '1', 't', 'f'].false?
	end

	test "should be false when empty" do
		assert ![].to_boolean
		assert ![].to_b
		assert ![].true?
		assert ![].false?
	end

	#	true_xor_false?
	test "should be true_xor_false? with only true" do
		assert [true].true_xor_false?
		assert ['true'].true_xor_false?
		assert [1].true_xor_false?
		assert ['1'].true_xor_false?
		assert ['t'].true_xor_false?
	end

	test "should be true_xor_false? with only false" do
		assert [false].true_xor_false?
		assert ['false'].true_xor_false?
		assert [0].true_xor_false?
		assert ['0'].true_xor_false?
		assert ['f'].true_xor_false?
	end

	test "should not be true_xor_false? with both true and false" do
		assert ![true,false].true_xor_false?
		assert !['true','false'].true_xor_false?
		assert ![1,0].true_xor_false?
		assert !['1','0'].true_xor_false?
		assert !['t','f'].true_xor_false?
	end

end
