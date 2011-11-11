require 'test_helper'

class CommonLib::HashExtensionTest < ActiveSupport::TestCase

	#	delete_keys_matching!(regex)

	#	delete_keys!(*keys)

	#	dig
	test "should return Gold when all keys match dig" do
		h = { :a => { :b => { :c => 'Gold' } } }
		assert_equal 'Gold', h.dig(:a,:b,:c)
	end

	test "should return nil when no key matching dig" do
		h = { :a => { :b => { :c => 'Gold' } } }
		assert_nil h.dig('a')
		assert_nil h.dig(:a,:b,:d)
		assert_nil h.dig(:d,:e,:f)
	end

	#	deep_stringify_keys
	test "should return hash with stringified keys" do
		h = { :a => { :b => { :c => 'Gold' } } }
		assert  h.has_key?(:a)
		assert !h.has_key?('a')
		assert  h[:a].has_key?(:b)
		assert !h[:a].has_key?('b')
		assert  h[:a][:b].has_key?(:c)
		assert !h[:a][:b].has_key?('c')
		s = h.deep_stringify_keys
		assert !s.has_key?(:a)
		assert  s.has_key?('a')
		assert !s['a'].has_key?(:b)
		assert  s['a'].has_key?('b')
		assert !s['a']['b'].has_key?(:c)
		assert  s['a']['b'].has_key?('c')
puts h.inspect
puts s.inspect
	end

end
