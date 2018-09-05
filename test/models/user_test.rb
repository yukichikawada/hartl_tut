require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Hartl", email: "michael@hartl.com",
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name isn't longer than 25 chars" do
    @user.name = "a" * 26
    assert_not @user.valid?
  end

  test "email isn't longer than 30 chars" do
    @user.email = "a" * 31
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do 
    valid_addresses = %w[user@email.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foot.jp alice+bob@baz.cn]

    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    dup_user = @user.dup                # i take this to mean the original user
    dup_user.email = @user.email.upcase # is no longer valid.
    @user.save                          # seems unnatural as the instance
    assert_not dup_user.valid?          # created second should be invalid
  end

  test "email addresses should be saved as lower-case" do
    mixed_case = "FoO@eXaMplE.COm"
    @user.email = mixed_case
    @user.save 
    assert_equal mixed_case.downcase, @user.reload.email
  end

  test "password should be present (non-blank)" do 
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
