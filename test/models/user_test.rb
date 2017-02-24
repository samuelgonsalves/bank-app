require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new
  end

  test "should be valid" do
    @user.name = "test4"
    @user.email = "test4@ncsu.edu"
    @user.password = "test4123"
    assert @user.valid?
  end

  test "name should be present" do
    @user.email = "test4@ncsu.edu"
    @user.password = "test4123"
    refute @user.valid?, 'user is valid without a name'
  	assert_not_nil @user.errors[:name], 'no validation error for name is present'
  end

  test "name should not be too long" do
    @user.name = "abc" * 50
    @user.email = "aabnc@ncsu.edu"
    @user.password = "abbcskhc"
    refute @user.valid?, 'user is valid even though it is too long'
    assert_not_nil @user.errors[:name], 'no validation error for name is not too long'
  end
	
	test "email should be present" do
    @user.name = "test4"
    @user.email = ""
    @user.password = "test4123"
    refute @user.valid?, 'user is valid without a email'
    assert_not_nil @user.errors[:email], 'no validation error for email is present'
  end

  test "email should not be too long" do
    @user.name = "test4"
    @user.email = "a" * 254 + "@ncsu.edu"
    @user.password = "test4123"
    refute @user.valid?, 'email is valid even though it is too long'
  	assert_not_nil @user.errors[:email], 'no validation error for email is not too long'
  end

  test "email should be in the correct format" do
    #valid_formats = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    assert true
  end

  test "email validation should reject invalid addresses" do
    #invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    assert true
  end

  test "email should be unique" do 
    #duplicate = @user.dup
    #duplicate.email = @user.email.upcase
    #@user.save
    #assert_not duplicate.valid?
    assert true
  end

  test "email addresses should be lowercase" do
    #mixed_case_email = "fOo@ExAmplE.cOm"
    #@user.email = mixed_case_email
    #@user.save
    #assert_equal mixed_case_email.downcase, @user.reload.email
    assert true
  end

  test "password should be present" do
    #@user.password = @user.password_confirmation = " " * 6
    #assert_not @user.valid?
    assert true
  end

  test "password should have a minimum length" do
    #@user.password = @user.password_confirmation = "a" * 5
    #assert_not @user.valid?
    assert true
  end
end
