require 'test_helper'

class KitTest < ActiveSupport::TestCase
# test validations
	def setup
		@kit = kits(:one)
	end

	test 'valid kit' do
		assert @kit.valid?
	end

	test 'invalid without location' do
		@kit.location = nil
		refute @kit.valid?
	end

# test relationships

	test 'kit 1 should have 1 reservation' do
		assert_equal 1, @kit.reservations.size
	end

	test 'kit 1 should have 1 item' do
		assert_equal 1, @kit.items.size
	end
	
end
