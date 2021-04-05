require "application_system_test_case"

class RolesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_roles_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Roles"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new role" do
    visit page_url
    fill_in "New Role", with: "New Role"
    click_on "Save"
    take_screenshot
    assert_text "Role was created successfully."
    assert_selector "#role_name", text: ""
  end

  test "can not add an empty role" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate role" do
    visit page_url
    fill_in "New Role", with: roles(:senior).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_role_url(roles(:senior), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a role" do
    visit page_url
    role = roles(:senior)

    assert_selector "li", text: role.name
    find("li", text: role.name).click_on("Delete")
    assert_no_selector "li", text: role.name
  end

  test "can edit role" do
    visit page_url
    role = roles(:senior)

    assert_selector "li", text: role.name
    find("li", text: role.name).click_on("Edit")
    within "turbo-frame#role_#{role.id}" do
      fill_in "role_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit role with exiting name" do
    visit page_url
    role = roles(:senior)
    junior = roles(:junior)

    assert_selector "li", text: role.name
    find("li", text: role.name).click_on("Edit")
    within "turbo-frame#role_#{role.id}" do
      fill_in "role_name", with: junior.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Roles selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "Roles"
    end
  end

  test "can not delete a role which is being used" do
    visit page_url
    role = roles(:junior)

    assert_selector "li", text: role.name
    find("li", text: role.name).click_on("Delete")
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: role.name
  end
end
