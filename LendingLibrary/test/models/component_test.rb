require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
# test validations
	def setup
		@comp = components(:one)
	end

	test 'valid component' do
		assert @comp.valid?
	end

	test 'invalid without max quantity' do
		@comp.max_quantity = nil
		refute @comp.valid?
	end

	test 'invalid without damaged' do
		@comp.damaged = nil
		refute @comp.valid?
	end

	test 'invalid without missing' do
		@comp.missing = nil
		refute @comp.valid?
	end

	test 'invalid without consumable' do
		@comp.consumable = nil
		refute @comp.valid?
	end

	test 'invalid without item id' do
		@comp.item_id = nil
		refute @comp.valid?
	end

	test 'invalid without component_category_id' do
		@comp.component_category_id = nil
		refute @comp.valid?
	end

	test 'consumable must be true or false' do
		@comp.consumable = false
		assert @comp.valid?
		@comp.consumable = true
		assert @comp.valid?
		@comp.consumable = "a"
		refute @comp.valid?
		@comp.consumable = 2
		refute @comp.valid?
	end

	test 'max quan, damaged, and missing should be integers >= 0' do
		@comp.max_quantity = 10
		@comp.damaged = 0
		@comp.missing = 0
		assert @comp.valid?

		@comp.max_quantity = -2
		refute @comp.valid?
		@comp.max_quantity = 10

		@comp.damaged = -1
		refute @comp.valid?
		@comp.damaged = 0

		@comp.missing = -1
		refute @comp.valid?
		@comp.missing = 0

		@comp.max_quantity = 10.1
		refute @comp.valid?
		@comp.max_quantity = 10

		@comp.damaged = 0.1
		refute @comp.valid?
		@comp.damaged = 0

		@comp.missing = 0.1
		refute @comp.valid?
		@comp.missing = 0

		@comp.max_quantity = 'text'
		refute @comp.valid?
		@comp.max_quantity = 10

		@comp.damaged = 'text'
		refute @comp.valid?
		@comp.damaged = 0

		@comp.missing = 'text'
		refute @comp.valid?
		
	end

	test 'damaged + missing <= max quan' do
		@comp.max_quantity = 10
		@comp.damaged = 2
		@comp.missing = 1
		assert @comp.valid?

		@comp.max_quantity = 3
		assert @comp.valid?

		@comp.max_quantity = 2
		refute @comp.valid?
	end

# test methods
	test 'good_condition method' do
		@comp.damaged = 0
		@comp.missing = 0
		assert @comp.good_condition
		@comp.damaged = 1
		refute @comp.good_condition
		@comp.damaged = 0
		@comp.missing = 1
		refute @comp.good_condition
	end
end
