require 'test_helper'

class SchoolTest < ActiveSupport::TestCase

# test validations
	def setup
		@school = schools(:one)
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

	test 'invalid without is_active' do
		@school.is_active = nil
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

	test 'invalid with invalid name' do
		@school.name = "123"
		refute @school.valid?
		@school.name = "@$<>"
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

	test 'invalid with invalid street 1' do
		@school.street_1 = "100 Generic Driver"
		refute @school.valid?
		@school.street_1 = "Generic Drive"
		refute @school.valid?
		@school.street_1 = "100 Drive"
		refute @school.valid?
		@school.street_1 = "1023"
		refute @school.valid?
		@school.street_1 = "place"
		refute @school.valid?
	end

	# do we need street 2 for our purposes?
	test 'invalid with invalid street 2' do
		@school.street_2 = "123"
		refute @school.valid?
		@school.street_2 = "place"
		refute @school.valid?
		@school.street_2 = "100 Generic Drive"
		refute @school.valid?
	end

	test 'invalid with invalid city' do
		@school.city = "123"
		refute @school.valid?
		@school.city = "Abxasflkajsfi"
		refute @school.valid?
	end

	test 'valid without street_2' do
		@school.street_2 = nil
		assert @school.valid?
	end



# test relationships

end
