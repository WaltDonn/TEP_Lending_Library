require 'test_helper'

class ReservationTest < ActiveSupport::TestCase

#test validations
	def setup
		@res = reservations(:one)
		@res3 = reservations(:three)
	end

	test 'valid reservation' do
		assert @res.valid?
	
		assert @res3.valid?
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
		refute @res.valid?
	end

	test 'valid without pick_up_date (as long as no return date either)' do
		@res.return_date = nil
		@res.pick_up_date = nil
		refute @res.valid?

		@res.return_date = Date.parse('2018-01-09')
		refute @res.valid?
	end

	test 'release form id must be a number > 0' do
		# need to figure out how we are handling the ids 
		@res.release_form_id = 1
		assert @res.valid?
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
		@res.pick_up_date = 9.days.ago
		@res.return_date = 2.days.ago
		assert @res.valid?

		@res.pick_up_date = 9.days.ago
		@res.return_date = 9.days.ago
		assert @res.valid?

		@res.pick_up_date = 2.days.ago
		@res.return_date = 9.days.ago
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

# test methods
	test 'past_due method' do
		refute @res3.past_due?
		@res3.returned = false
		assert @res3.past_due?
	end

	test 'reservations made to kits that are inactive or blacked out are not valid' do
		# this should be a validation on_create, not a general validation because what if kits from old reservations get blacked out or become inactive?

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, returned: false, picked_up: false, release_form_id: 1, kit_id: 3, teacher_id: 7) 
		assert @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, returned: false, picked_up: false, release_form_id: 1, kit_id: 4, teacher_id: 7)
		refute @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, returned: false, picked_up: false, release_form_id: 2, kit_id: 5, teacher_id: 7)
		refute @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, returned: false, picked_up: false, release_form_id: 3, kit_id: 6, teacher_id: 7)
		refute @extra_res.valid?
		@extra_res.delete

	end

	test 'volunteer(s) present and returned method' do
		@extra_res = Reservation.new(start_date: Date.current, end_date: Date.tomorrow, pick_up_date: Date.current, return_date: Date.current, returned: true, picked_up: true, release_form_id: 1, kit_id: 3, teacher_id: 7, user_check_in_id: 2, user_check_out_id: 2 )
		assert @extra_res.valid?
		@extra_res.delete

		#volunteer_id nil but returned
		@extra_res = Reservation.new(start_date: Date.current, end_date: Date.tomorrow, pick_up_date: Date.current, return_date: Date.current, returned: true, picked_up: true, release_form_id: 1, kit_id: 3, teacher_id: 7, user_check_in_id: 2 )
		#@extra_res.save!
		refute @extra_res.valid?
		@extra_res.delete


		#volunteer id is not valid volunteer id
		@extra_res = Reservation.new(start_date: Date.current, end_date: Date.tomorrow, pick_up_date: Date.current, return_date: Date.current, returned: true, picked_up: true, release_form_id: 1, kit_id: 3, teacher_id: 7, user_check_in_id: 2, user_check_out_id: 6 )
		refute @extra_res.valid?
		@extra_res.delete
	end

	test 'a kit cannot be returned before it is picked up' do
		assert @res.valid?
		@res.picked_up = false
		refute @res.valid?
	end

	test 'picked up kits should have a volunteer that checked them out' do
		assert @res.valid?
		@res.user_check_out_id = nil
		refute @res.valid?

		@res.user_check_out_id = 3
		refute @res.valid?
	end

	test 'checked in kits should have a volunteer that checked them in' do
		assert @res.valid?
		@res.user_check_in_id = nil
		refute @res.valid?

		@res.user_check_in_id = 3
		refute @res.valid?
	end

	test 'kits should be reserved by a valid active teacher' do
		assert @res.valid?
		@res.teacher_id = nil
		refute @res.valid?

		@res.teacher_id = 99
		refute @res.valid?

		@res.teacher_id = 8
		refute @res.valid?

		@res.teacher_id = 2
		refute @res.valid?
	end

	test 'teacher cannot rent a kit if they already have one out' do
		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, kit_id: 1, teacher_id: 4 )
		assert @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, kit_id: 1, teacher_id: 3 )
		refute @extra_res.valid?
	end

	test 'teacher id cannot be nil for reservations' do
		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, kit_id: 1, teacher_id: 4 )
		assert @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, kit_id: 1)
		refute @extra_res.valid?
	end

	test 'kit id cannot be nil for reservations' do
		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, kit_id: 1, teacher_id: 4 )
		assert @extra_res.valid?
		@extra_res.delete

		@extra_res = Reservation.new(start_date: Date.tomorrow, end_date: 10.days.from_now, pick_up_date: Date.tomorrow, return_date: 10.days.from_now, picked_up: false, returned: false, release_form_id: 001, teacher_id: 4 )
		refute @extra_res.valid?
	end

end
