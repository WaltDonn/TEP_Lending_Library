require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

# test validations
	def setup
		@school = schools(:one)
		@school2 = schools(:two)
		@school3 = schools(:three)
		@school4 = schools(:four)
	end

	test 'valid school' do
		assert @school.valid?
	end

	test 'invalid without name' do
		@school.name = nil
		refute @school.valid?
	end

	test 'invalid without street_1' do
		@school.street_1 = nil
		refute @school.valid?
	end

	test 'invalid without city' do
		@school.city = nil
		refute @school.valid?
	end

	test 'invalid without state' do
		@school.state = nil
		refute @school.valid?
	end

	test 'invalid without zip' do
		@school.zip = nil
		refute @school.valid?
	end

	test 'invalid with invalid zip format' do
		@school.zip = "123456"
		refute @school.valid?
		@school.zip = "1234"
		refute @school.valid?
		@school.zip = "ABCDE"
		refute @school.valid?
	end


	test 'invalid with invalid state' do
		@school.state = "PA"
		assert @school.valid?
		@school.state = "TX"
		assert @school.valid?
		@school.state = "AA"
		refute @school.valid?
		@school.state = "12"
		refute @school.valid?
		@school.state = "PAZ"
		refute @school.valid?
	end


	test 'valid without street_2' do
		@school.street_2 = nil
		assert @school.valid?
	end


# test relationships

	test 'school 1 should have 2 teachers' do
		assert_equal 2, @school.users.size
	end

# test scopes

	test 'alphabetical scope should put schools in proper order' do
		assert_equal School.alphabetical.map{|c| c.id}, [2, 1, 3, 4]
	end

	test 'should be 2 active schools' do
		assert_equal School.active.size, 3
	end

	test 'should be 1 inactive school' do
		assert_equal School.inactive.size, 1
	end


# test callback?

	test 'should not be destroyed when delete is attempted' do
		@school.destroy
		assert @school.valid?
	end

# test methods
	test 'school is not a duplicate & already_exists? methods' do
		@school4 = School.new(name: 'An Elementary School', street_1: '100 Learn Street', street_2: 'SMC 100', city: 'Pittsburgh', state: 'PA', zip: '15212', is_active: true)
		assert @school4.valid?
		@school5 = School.new(name: 'Generic Elementary', street_1: '100 Learn Street', street_2: 'SMC 100', city: 'Pittsburgh', state: 'PA', zip: '15212', is_active: true)
		assert @school5.valid?
		@school6 = School.new(name: 'An Elementary School', street_1: '100 Learn Street', street_2: 'SMC 100', city: 'Pittsburgh', state: 'PA', zip: '15213', is_active: true)
		assert @school6.valid?
		@school7 = School.new(name: 'Generic Elementary', street_1: '100 Learn Street', street_2: 'SMC 100', city: 'Pittsburgh', state: 'PA', zip: '15213', is_active: true)
		refute @school7.valid?
	end

	test 'no outstanding reservations' do
		#Alex -- why is this a validation? 

		# school with no teachers should have NO outstanding
		assert @school3.no_outstanding_reservations

		# school with teachers with no reservations should have NO outstanding
		assert @school2.no_outstanding_reservations

		# school with teachers with no outstanding should have NO outstanding
		assert @school4.no_outstanding_reservations

		# school with outstanding should have outstanding
		refute @school1.no_outstanding_reservations
	end

	test 'should set all teachers to inactive if set school to inactive' do
		@school4.is_active = false
		assert_equal @school4.users.map{|c| c.is_active}, [true]
		@school4.save
		assert_equal @school4.users.map{|c| c.is_active}, [false]

		# i think issues with no outstanding reservations is affecting this?
		@school.is_active = false
		assert_equal @school.users.map{|c| c.is_active}, [true, true]
		@school.save
		assert_equal @school.users.map{|c| c.is_active}, [false, false]
	end

end
