require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    
    # Login as a user before running tests
    visit new_session_url
    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    
    # Wait for redirect to complete
    assert_no_text "Sign in"
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    fill_in "Name", with: "New User"
    fill_in "Email address", with: "newuser@example.com"
    fill_in "Password", with: "secret"
    fill_in "Confirm", with: "secret"
    click_on "Create User"

    assert_text "successfully created"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit"

    fill_in "Name", with: "Updated Name"
    fill_in "Email address", with: "updated@example.com"
    fill_in "Password", with: "secret"
    fill_in "Confirm", with: "secret"
    click_on "Update User"

    assert_text "successfully updated"
  end

  test "should destroy User" do
    # Create another user so we don't delete the one we're logged in as
    other_user = User.create!(
      name: "Delete Me", 
      email_address: "delete@example.com", 
      password: "password", 
      password_confirmation: "password"
    )
    
    visit user_url(other_user)
    accept_confirm { click_on "Destroy" }

    assert_text "successfully destroyed"
  end
end
