require "application_system_test_case"

class PeopleStatusesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_people_statuses_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "People Status"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new people status" do
    visit page_url
    fill_in "Add New Status", with: "New Status"
    choose(option: 'green')
    click_on "Save"
    take_screenshot
    assert_text "People Status was created successfully."
    assert_selector "#people_status_name", text: ""
  end

  test "can not add an empty people status" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate people status" do
    visit page_url
    fill_in "Add New Status", with: people_statuses(:deployed).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_people_status_url(people_statuses(:deployed), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a people status" do
    visit page_url
    people_status = people_statuses(:deployed)

    assert_selector "li", text: people_status.name
    find("li", text: people_status.name).click_on("Delete")
    assert_no_selector "li", text: people_status.name
  end

  test "can edit people status" do
    visit page_url
    people_status = people_statuses(:deployed)

    assert_selector "li", text: people_status.name
    find("li", text: people_status.name).click_on("Edit")
    within "turbo-frame#people_status_#{people_status.id}" do
      fill_in "people_status_name", with: "Edited Name"
      choose(option: 'green')
      click_on "Save"
      take_screenshot
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit people status with exiting name" do
    visit page_url
    people_status = people_statuses(:deployed)
    bench = people_statuses(:bench)

    assert_selector "li", text: people_status.name
    find("li", text: people_status.name).click_on("Edit")
    within "turbo-frame#people_status_#{people_status.id}" do
      fill_in "people_status_name", with: bench.name
      choose(option: 'green')
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with People Status selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "People Status"
    end
  end

  test "can not delete a people status which is being used" do
    visit page_url
    people_status = people_statuses(:deployed)

    assert_selector "li", text: people_status.name
    find("li", text: people_status.name).click_on("Delete")
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: people_status.name
    take_screenshot
  end
end
