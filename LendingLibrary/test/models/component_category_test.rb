require 'test_helper'

class ComponentCategoryTest < ActiveSupport::TestCase
# test validations
	def setup
		@comp_cat = component_categories(:one)
		@comp_cat2 = component_categories(:two)
	end

	test 'valid comp cat' do
		assert @comp_cat.valid?
	end

	test 'invalid without name' do
		assert @comp_cat.valid?
		@comp_cat.name = nil
		refute @comp_cat.valid?
	end

	test 'invalid without description' do
		assert @comp_cat.valid?
		@comp_cat.description = nil
		refute @comp_cat.valid?
	end

# test relationships
	test 'compCat 1 should have 1 component' do
		assert_equal 1, @comp_cat.components.size
		assert_equal 1, @comp_cat2.components.size
	end
end
