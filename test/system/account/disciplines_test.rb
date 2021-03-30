require "application_system_test_case"

class DisciplinesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_disciplines_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Disciplines"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new discipline" do
    visit page_url
    fill_in "Add New Discipline", with: "New Discipline"
    click_on "Save"
    take_screenshot
    assert_text "Discipline was created successfully."
    assert_selector "#discipline_name", text: ""
  end

  test "can not add an empty discipline" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate discipline" do
    visit page_url
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
    visit page_url
    discipline = disciplines(:hr)

    assert_selector "li", text: discipline.name
    find("li", text: discipline.name).click_on("Delete")
    assert_no_selector "li", text: discipline.name
  end

  test "can edit discipline" do
    visit page_url
    discipline = disciplines(:hr)

    assert_selector "li", text: discipline.name
    find("li", text: discipline.name).click_on("Edit")
    within "turbo-frame#discipline_#{discipline.id}" do
      fill_in "discipline_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Disciplines selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "Disciplines"
    end
  end

  test "can not edit discipline with exiting name" do
    visit page_url
    discipline = disciplines(:hr)
    engineering = disciplines(:engineering)

    assert_selector "li", text: discipline.name
    find("li", text: discipline.name).click_on("Edit")
    within "turbo-frame#discipline_#{discipline.id}" do
      fill_in "discipline_name", with: engineering.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "can not delete a discipline which is being used" do
  end
end
