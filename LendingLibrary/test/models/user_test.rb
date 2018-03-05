require 'test_helper'


class UserTest < ActiveSupport::TestCase
  # test validations
	def setup
		@user = users(:one)
		@user3 = users(:three)
	end

	test 'valid user' do
		assert @user.valid?
		assert @user3.valid?
	end

	test 'invalid without email' do
		@user.email = nil
		refute @user.valid?
	end

	test 'invalid without first_name' do
		@user.first_name = nil
		refute @user.valid?
	end

	test 'invalid without last_name' do
		@user.last_name = nil
		refute @user.valid?
	end

	test 'invalid without role' do
		@user.role = nil
		refute @user.valid?
	end

	test 'invalid without pw' do
		#I think devise will handle this for us?
		#this should only happen on edit, and devise handles the edit /update logic
		@user.encrypted_password = nil
		refute @user.valid?
	end

	test 'invalid with invalid email format' do
		@user.email = "123456"
		refute @user.valid?
		@user.email = "abcdas"
		refute @user.valid?
		@user.email = "example@"
		refute @user.valid?
		@user.email = "@gmail.com"
		refute @user.valid?
		@user.email = "123@123"
		refute @user.valid?
		@user.email = "123@123."
		refute @user.valid?
		@user.email = "example@gmail.falskdfjas"
		refute @user.valid?
	end

	test 'invalid with invalid first/last name' do
		@user.first_name = "Pat123rick"
		refute @user.valid?
		@user.last_name = "Pat123rick"
		refute @user.valid?
		@user.first_name = "Pat@rick"
		refute @user.valid?
		@user.last_name = "Pat@rick"
		refute @user.valid?
	end

	test 'invalid with non-existant school_id' do
		@user.school_id = "999"
		refute @user.valid?
	end

	test 'invalid with non-existant role' do
		@user.role = "volunteer"
		assert @user.valid?
		@user.role = "manager"
		assert @user.valid?
		@user.role = "teacher"
		@user.class_size = 4
		assert @user.valid?
		@user.role = "other"
		refute @user.valid?
		@user.role = "123"
		refute @user.valid?
	end

	test 'invalid with invalid phone_num' do
		@user.phone_num = "(41)-(000)-9999"
		refute @user.valid?
		@user.phone_num = "HelloWorld"
		refute @user.valid?
		@user.phone_num = "4A1A2-0A0A0-9A9A9A9"
		refute @user.valid?
	end

	test 'valid with many forms of phone num' do
		@user.phone_num = "(412)-000-9999"
		assert @user.valid?
		@user.phone_num = "4120009999"
		assert @user.valid?
		@user.phone_num = "412-000-9999"
		assert @user.valid?
	end


	test 'valid without phone num' do
		@user.phone_num = nil
		assert @user.valid?
	end

	test 'valid without school id' do
		@user.school_id = nil
		assert @user.valid?
	end


# test relationships
	test 'user 3 should have 2 reservations' do
		assert_equal 2, @user3.owned_reservations.size
	end

# test scopes
	test 'alphabetical should order users by last name then first name' do
		assert_equal User.alphabetical.map{|c| c.id}, [5, 7, 3, 1, 2, 4, 6]
	end

	#test active/inactive scopes?

	test 'there should be 2 employees' do
		assert_equal 2, User.employees.size
	end

	test 'there should be 4 teachers' do
		assert_equal 4, User.teachers.size
	end

	test 'there should be 1 volunteer' do
		assert_equal 1, User.volunteers.size
	end

# test callback? reformat phone?
	test 'should not be destroyed when delete is attempted' do
		@user.destroy
		refute @user.destroyed?
	end

# test methods
	test 'test can_checkin method, only non-teacher active roles should be able to check in' do
		assert @user.can_checkin

		@user.is_active = false
		refute @user.can_checkin

		@user.is_active = true
		@user.role = "Teacher"
		refute @user.can_checkin
	end

	test 'name method' do
		assert_equal @user.name, "Smith, John"
	end

	test 'self authenticate method' do
		# unsure how to test this
		assert false
	end

	test 'has outstanding kits method' do
		#method throws errors right now
		assert @user3.has_outstanding_kit
	end

	test 'class size present method' do
		#failing because not being case insensitive throughout model i.e. Teacher != teacher
		assert @user3.valid?
		@user3.class_size = nil
		refute @user3.valid?
		assert @user3.class_size = 0
		refute @user3.valid?
		assert @user3.class_size = -1
		refute @user3.valid?
	end

	test 'teachers should not be connected to inactive schools' do
		assert @user3.valid?
		@user3.school_id = 3
		refute @user3.valid?
	end

	test 'reformat phone before save' do
		assert_equal "412-000-9999", @user.phone_num
		@user.save
		assert_equal "4120009999", @user.phone_num
	end



end
