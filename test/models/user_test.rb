require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test validations
	def setup
		@user = users(:one)
		@user2 = users(:two)
		@user3 = users(:three)
		@user4 = users(:four)
		@user5 = users(:five)
		@user6 = users(:six)
		@user7 = users(:seven)
		@user8 = users(:eight)
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

	#devise should handle pw presence validations

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
		assert_equal User.alphabetical.map{|c| c.id}, [5, 8, 7, 3, 1, 2, 4, 6]
	end

	test 'there should be 3 employees' do
		assert_equal 3, User.employees.size
	end

	test 'there should be 5 teachers' do
		assert_equal 5, User.teachers.size
	end

	test 'there should be 1 volunteer' do
		assert_equal 1, User.volunteers.size
	end

# test callback? reformat phone?
	test 'should not be destroyed when delete is attempted' do
		byebug
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

	test 'has outstanding kits method' do
		assert @user3.has_outstanding_kit
	end


	test 'class size present method' do
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

	test 'can rent method' do
		assert @user.can_rent
		refute @user2.can_rent
		assert @user3.can_rent
		assert @user4.can_rent
		assert @user5.can_rent
		assert @user6.can_rent
		assert @user7.can_rent
		refute @user8.can_rent
	end

	test 'has_role? method' do
		refute @user.has_role?(nil)
		refute @user.has_role?(:teacher)
		assert @user.has_role?(:admin)
	end



end
