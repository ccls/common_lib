require 'test_helper'

class CommonLib::HashExtensionTest < ActiveSupport::TestCase

#		def delete_keys_matching!(regex)
#		def delete_keys!(*keys)
#		def dig(*args)

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

end
