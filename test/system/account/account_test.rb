require "application_system_test_case"

class AccountTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    detail_url(script_name: "/#{@account.id}")
  end

  test "can visit page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Account Settings"
  end

  test "can not visit page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can update account name" do
    visit page_url
    fill_in "Company Name", with: "Awesome Company"
    click_on "Save"
    take_screenshot
    assert_text "Account was updated successfully"
  end

  test "can not update account with empty name" do
    visit page_url
    fill_in "Company Name", with: ""
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end
end
