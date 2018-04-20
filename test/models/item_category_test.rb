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

# test relationships
	test 'itemCat 1 should have 7 items' do
		assert_equal 7, @item_cat.items.size
	end

# test methods
	test 'one components group' do
		assert_equal 2, @item_cat.one_components_group.size
	end

end
