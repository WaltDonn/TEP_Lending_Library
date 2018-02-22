require 'test_helper'

class ComponentCategoryTest < ActiveSupport::TestCase
# test validations
	def setup
		@comp_cat = component_categories(:one)
	end

	test 'valid comp cat' do
		assert @comp_cat.valid?
	end

	test 'invalid without name' do
		@comp_cat.name = nil
		refute @comp_cat.valid?
	end

	test 'invalid without description' do
		@comp_cat.description = nil
		refute @comp_cat.valid?
	end
end
