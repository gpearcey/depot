require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "first user creation when no users exist" do
    # Clear all users to simulate fresh installation
    User.delete_all
    
    visit new_session_url
    
    fill_in "email_address", with: "admin@example.com"
    fill_in "password", with: "password"
    click_on "Sign in"
    
    assert_text "First administrator created"
    assert User.exists?(email_address: "admin@example.com")
  end
  
  test "normal login with existing users" do
    user = users(:one)
    
    visit new_session_url
    
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    
    # Should be redirected to admin area or wherever after_authentication_url goes
    assert_no_text "First administrator created"
  end
  
  test "failed login with wrong credentials" do
    visit new_session_url
    
    fill_in "email_address", with: "wrong@example.com"
    fill_in "password", with: "wrongpassword"
    click_on "Sign in"
    
    assert_text "Try another email address or password"
  end
end
