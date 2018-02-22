require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test validations
	def setup
		@user = users(:one)
	end

	test 'valid user' do
		assert @user.valid?
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

	test 'invalid without pw digest' do
		@user.password_digest = nil
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
		@user.phone_num = "(412)-(000)-9999"
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
end
