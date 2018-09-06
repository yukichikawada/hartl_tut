require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "Invalid user signup" do
    get signup_path
    assert_no_difference 'User.count' do  # This pattern keeps track of count
      post users_path, params: {          # of value prior to POST
          user: {                          # and compares to value after POST
            name: 'username',
            email: 'user@invalid.com',
            password: 'foo',
            password_confirmation: 'bar' 
          } 
        }
    end                                   # User#create should fail,
    assert_template 'users/new'           # new template should render w/errors
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors>input#user_password'
  end

  test "Valid user signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
          user: {
            name: 'username',
            email: 'user@valid.com',
            password: '123456',
            password_confirmation: '123456' 
          } 
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash[:success]
    assert_select 'div.alert-success'
  end
end
