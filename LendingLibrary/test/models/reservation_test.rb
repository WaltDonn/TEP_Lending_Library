require 'test_helper'

class ReservationTest < ActiveSupport::TestCase

# test validations
	def setup
		@res = reservations(:one)
	end

	test 'valid reservation' do
		assert @res.valid?
	end

	test 'invalid without start date' do
		@res.start_date = nil
		refute @res.valid?
	end

	test 'invalid without end date' do
		@res.end_date = nil
		refute @res.valid?
	end

	test 'invalid without form id' do
		@res.release_form_id = nil
		refute @res.valid?
	end

	test 'invalid without kit id' do
		@res.kit_id = nil
		refute @res.valid?
	end

	test 'invalid without user id' do
		@res.release_form_id = nil
		refute @res.valid?
	end

	test 'invalid without returned value' do
		@res.returned = nil
		refute @res.valid?
	end

	test 'valid without return_date' do
		@res.return_date = nil
		assert @res.valid?
	end

	test 'valid without pick_up_date (as long as no return date either)' do
		@res.return_date = nil
		@res.pick_up_date = nil
		assert @res.valid?

		@res.return_date = Date.parse('2018-01-09')
		refute @res.valid?
	end

	test 'returned must be true or false' do
		@res.returned = 'a'
		refute @res.valid?
		@res.returned = '1'
		refute @res.valid?
		@res.returned = true
		assert @res.valid?
		@res.returned = false
		assert @res.valid?
	end

	test 'release form id must be a number > 0' do
		@res.release_form_id = 0
		refute @res.valid?
		@res.release_form_id = -1
		refute @res.valid?
		@res.release_form_id = 'a'
		refute @res.valid?
	end

	test 'start date <= end date' do
		@res.start_date = Date.parse('2018-01-02')
		@res.end_date = Date.parse('2018-01-02')
		assert @res.valid?

		@res.start_date = Date.parse('2018-01-01')
		@res.end_date = Date.parse('2018-01-02')
		assert @res.valid?

		@res.start_date = Date.parse('2018-01-02')
		@res.end_date = Date.parse('2018-01-01')
		refute @res.valid?
	end

	test 'pick-up date <= return date' do
		@res.pick_up_date = Date.parse('2018-01-02')
		@res.return_date = Date.parse('2018-01-02')
		assert @res.valid?

		@res.pick_up_date = Date.parse('2018-01-02')
		@res.return_date = Date.parse('2018-01-03')
		assert @res.valid?

		@res.pick_up_date = Date.parse('2018-01-02')
		@res.return_date = Date.parse('2018-01-01')
		refute @res.valid?
	end

	test 'start date <= pick up date' do
		@res.start_date = Date.parse('2018-01-02')
		@res.pick_up_date = Date.parse('2018-01-02')
		assert @res.valid?

		@res.start_date = Date.parse('2018-01-02')
		@res.pick_up_date = Date.parse('2018-01-03')
		assert @res.valid?

		@res.start_date = Date.parse('2018-01-02')
		@res.pick_up_date = Date.parse('2018-01-01')
		refute @res.valid?
	end

	# test 'return date <= end_date' do
	# 	@res.return_date = Date.parse('2018-01-02')
	# 	@res.end_date = Date.parse('2018-01-02')
	# 	assert @res.valid?

	# 	@res.return_date = Date.parse('2018-01-02')
	# 	@res.end_date = Date.parse('2018-01-03')
	# 	assert @res.valid?

	# 	@res.return_date = Date.parse('2018-01-02')
	# 	@res.end_date = Date.parse('2018-01-01')
	# 	refute @res.valid?
	# end

end
