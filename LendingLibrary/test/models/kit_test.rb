require 'test_helper'

class KitTest < ActiveSupport::TestCase
# test validations
	def setup
		@kit = kits(:one)
		@kit2 = kits(:two)
		@kit3 = kits(:three)
		@kit4 = kits(:four)
		@kit5 = kits(:five)
		@kit6 = kits(:six)
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

	test 'kit 1 should have 2 items' do
		assert_equal 2, @kit.items.size
	end

# test methods
	
	test 'test black out all and light up all' do
		Kit.blackout_all
		assert @kit.blackout
		assert @kit2.blackout
		assert @kit3.blackout
		assert @kit4.blackout
		assert @kit5.blackout
		assert @kit6.blackout
		
		Kit.lightup_all
		refute @kit.blackout
		refute @kit2.blackout
		refute @kit3.blackout
		refute @kit4.blackout
		refute @kit5.blackout
		refute @kit6.blackout
	end

	
end
