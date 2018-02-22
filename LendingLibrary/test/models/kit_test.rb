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
	
end
