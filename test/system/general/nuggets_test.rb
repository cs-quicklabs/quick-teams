require "application_system_test_case"

class NuggetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @nugget = nuggets(:one)
    sign_in @user
  end

  def page_url
    nuggets_url(script_name: "/#{@account.id}")
  end

  def nuggets_page_url
    nuggets_url(script_name: "/#{@account.id}", nugget_id: @nugget.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Nuggets"
    assert_text "New Nugget"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show nugget detail page" do
    visit page_url
    find(id: dom_id(@nugget)).click
    within "#nugget-header" do
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "can create a new nugget" do
    visit page_url
    skill = skills(:ruby).name
    click_on "New Nugget"
    fill_in "nugget_title", with: "Nugget"
    select skill, from: "nugget_skill_id"
    fill_in_rich_text_area "new_nugget", with: "This is some nugget"
    click_on "Save Nugget"
    take_screenshot
    assert_selector "p.notice", text: "Nugget was created successfully."
  end

  test "can not create with empty Name Discription nugget_type nugget_for" do
    visit page_url
    click_on "New Nugget"
    assert_selector "h1", text: "Add New Nugget"
    click_on "Save Nugget"
    take_screenshot
    assert_selector "h1", text: "Add New Nugget"
  end

  test "can edit a nugget" do
    visit page_url
    find(id: dom_id(@nugget)).click
    within "#nugget-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Nugget"
    fill_in "nugget_title", with: "Nugget"
    fill_in_rich_text_area dom_id(@nugget), with: "This is some nugget"
    click_on "Save Nugget"
    assert_selector "p.notice", text: "Nugget was updated successfully."
  end

  test "can not edit a nugget with invalid name" do
    visit page_url
    find(id: dom_id(@nugget)).click
    within "#nugget-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Nugget"
    fill_in "nugget_title", with: ""
    click_on "Save Nugget"
    take_screenshot
  end

  test "can delete nugget" do
    visit page_url
    find(id: dom_id(@nugget)).click
    within "#nugget-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Nugget was removed successfully."
  end
end
