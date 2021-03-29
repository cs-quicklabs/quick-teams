require "application_system_test_case"

class DisciplinesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  test "can visit the index if logged in" do
    visit account_disciplines_url(script_name: "/#{@account.id}")
    take_screenshot
    assert_selector "h1", text: "Disciplines"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit account_disciplines_url(script_name: "/#{@account.id}")
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new discipline" do
    visit account_disciplines_url(script_name: "/#{@account.id}")
    fill_in "Add New Discipline", with: "New Discipline"
    click_on "Save"
    take_screenshot
    assert_text "Discipline was created successfully."
  end

  test "can not add an empty discipline" do
    visit account_disciplines_url(script_name: "/#{@account.id}")
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate discipline" do
    visit account_disciplines_url(script_name: "/#{@account.id}")
    fill_in "Add New Discipline", with: disciplines(:engineering).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_discipline_url(disciplines(:engineering), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a discipline" do
  end

  test "can not delete a discipline which is being used" do
  end

  test "can edit discipline" do
  end

  test "can not edit discipline with exiting name" do
  end

  test "should have nav bar" do
  end

  test "should have left menu" do
  end
end
