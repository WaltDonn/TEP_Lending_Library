require 'test_helper'

class ItemCategoryTest < ActiveSupport::TestCase

# test validations
	def setup
		@item_cat = item_categories(:one)
	end

	test 'valid item category' do
		assert @item_cat.valid?
	end

	test 'invalid without name' do
		@item_cat.name = nil
		refute @item_cat.valid?
	end

	test 'invalid without description' do
		@item_cat.description = nil
		refute @item_cat.valid?
	end

	test 'invalid without inventory_level' do
		@item_cat.inventory_level = nil
		refute @item_cat.valid?
	end

	test 'invalid without amount_available' do
		@item_cat.amount_available = nil
		refute @item_cat.valid?
	end

	test 'inventory_level >= amount_available >= 0 integers' do
		@item_cat.amount_available = 0
		@item_cat.inventory_level = 0
		assert @item_cat.valid?

		@item_cat.amount_available = 5
		@item_cat.inventory_level = 10
		assert @item_cat.valid?

		@item_cat.amount_available = 5
		@item_cat.inventory_level = 3
		refute @item_cat.valid?

		@item_cat.amount_available = -1
		@item_cat.inventory_level = 10
		refute @item_cat.valid?

		@item_cat.amount_available = -2
		@item_cat.inventory_level = -1
		refute @item_cat.valid?

		@item_cat.amount_available = 0
		@item_cat.inventory_level = -1
		refute @item_cat.valid?

		@item_cat.amount_available = 0
		@item_cat.inventory_level = 0.1
		refute @item_cat.valid?

		@item_cat.amount_available = 0.1
		@item_cat.inventory_level = 2
		refute @item_cat.valid?
	end

# test relationships
	test 'itemCat 1 should have 1 item' do
		assert_equal 1, @item_cat.items.size
	end

# test methods
	test 'more_available method' do
		assert @item_cat.more_available
		@item_cat.amount_available = 0
		refute @item_cat.more_available
	end


# test mount_uploader?





end
