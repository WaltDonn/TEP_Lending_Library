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

# test scopes
	
	test 'visible kits scope' do
		assert_equal Kit.visible_kits.map{|c| c.id}, [1, 2, 3]
	end


# test methods
	
	test 'test black out all' do
		Kit.blackout_all

		@kit.reload
		@kit2.reload
		@kit3.reload
		@kit4.reload
		@kit5.reload
		@kit6.reload

		assert @kit.blackout
		assert @kit2.blackout
		assert @kit3.blackout
		assert @kit4.blackout
		assert @kit5.blackout
		assert @kit6.blackout
	end

	test 'test light up all' do
		Kit.lightup_all

		@kit.reload
		@kit2.reload
		@kit3.reload
		@kit4.reload
		@kit5.reload
		@kit6.reload

		refute @kit.blackout
		refute @kit2.blackout
		refute @kit3.blackout
		refute @kit4.blackout
		refute @kit5.blackout
		refute @kit6.blackout
	end

	test 'test available kits method' do
		assert_equal Kit.available_kits.map{|k| k.id}, [2, 3]
	end

	test 'test damaged kits method' do
		assert_equal Kit.damaged.map{|k| k.id}, [1]
	end

	test 'rental categories method' do
		assert_equal Kit.rental_categories.size, 1
	end

	test 'available for item category' do
		assert_equal Kit.available_for_item_category(Kit.rental_categories.first).size, 2
	end

	test 'top kits' do
		assert Kit.top_kits
	end

	test 'get photo' do
		assert @kit.photo
	end

	test 'get name' do
		assert_equal @kit.name, "Buzz Bot"
	end

	test 'get inventory' do
		assert_equal @kit.inventory, 3
	end

	test 'set and unset reserve' do
		refute @kit.reserved
		@kit.set_reserved
		assert @kit.reserved
		@kit.unset_reserved
		refute @kit.reserved
	end

	test 'kits cant be destroyed if they have items' do
		@kit.destroy
		assert @kit
	end



	
end
