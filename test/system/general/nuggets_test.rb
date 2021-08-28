require "application_system_test_case"

class NuggetsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @nuggets = @user.nuggets.includes(:user)
    @nugget = @user.nuggets.first
    sign_in @user
  end

  def page_url
    nuggets_url(script_name: "/#{@account.id}")
  end

  def nugget_page_url
    nugget_url(script_name: "/#{@account.id}", nugget_id: @nugget.id)
  end

  test "admin can see nuggets" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Nuggets"
    assert_text "New Nugget"
  end

  test "lead can see nuggets created by him" do
    sign_out @user
    @lead = users(:lead)
    sign_in @lead
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Nuggets"
    assert_text "New Nugget"
    @lead.added_nuggets.each do |nugget|
      find("tr", id: dom_id(nugget)).assert_selector "td", text: nugget.user.decorate.display_name
    end
  end

  test "member can not see nuggets" do
    sign_out @user
    @member = users(:member)
    sign_in @member
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "admin can add nugget" do
    visit new_nugget_url(script_name: "/#{@account.id}")
    take_screenshot
    assert_selector "h1", text: "Add New Nugget"
    fill_in "Title", with: "Test Nugget"
    fill_in_rich_text_area "new_nugget", with: "This is nugget body"
    select skills(:ruby).name, from: "nugget_skill_id"
    click_on "Save Nugget"
    assert_selector "p.notice", text: "Nugget was added successfully."
  end

  test "lead can add nugget" do
    sign_out @user
    @lead = users(:lead)
    sign_in @lead
    visit new_nugget_url(script_name: "/#{@lead.account.id}")
    take_screenshot
    assert_selector "h1", text: "Add New Nugget"
    fill_in "Title", with: "Test Nugget"
    fill_in_rich_text_area "new_nugget", with: "This is nugget body"
    select skills(:ruby).name, from: "nugget_skill_id"
    click_on "Save Nugget"
    assert_selector "p.notice", text: "Nugget was added successfully."
  end

  test "member can not add nugget" do
    sign_out @user
    @member = users(:member)
    sign_in @member
    visit new_nugget_url(script_name: "/#{@member.account.id}")
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "admin can edit unpublished nugget" do
    @nugget = Nugget.where(published: false).first
    visit edit_nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    fill_in "Title", with: "Test Nugget Edited"
    fill_in_rich_text_area dom_id(@nugget), with: "This is nugget body"
    select skills(:ruby).name, from: "nugget_skill_id"
    click_on "Save Nugget"
    assert_selector "p.notice", text: "Nugget was updated successfully."
    @nugget.reload
    assert_equal @nugget.title, "Test Nugget Edited"
  end

  test "lead can edit unpublished nugget create by him" do
    sign_out @user
    @lead = users(:lead)
    sign_in @lead
    @nugget = Nugget.where(published: false, user: @lead).first
    visit edit_nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    fill_in "Title", with: "Test Nugget Edited"
    fill_in_rich_text_area dom_id(@nugget), with: "This is nugget body"
    select skills(:ruby).name, from: "nugget_skill_id"
    click_on "Save Nugget"
    assert_selector "p.notice", text: "Nugget was updated successfully."
    @nugget.reload
    assert_equal @nugget.title, "Test Nugget Edited"
  end

  test "member can not edit nuggets" do
    sign_out @user
    @member = users(:member)
    sign_in @member
    @nugget = Nugget.first
    visit edit_nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "admin can delete any nugget" do
    @nugget = Nugget.first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    page.accept_confirm do
      click_on "Delete"
    end
    assert_selector "p.notice", text: "Nugget was removed successfully."
  end

  test "lead can delete unpublished nugget created by him" do
    sign_out @user
    @lead = users(:lead)
    sign_in @lead
    @nugget = Nugget.where(published: false, user: @lead).first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    page.accept_confirm do
      click_on "Delete"
    end
    assert_selector "p.notice", text: "Nugget was removed successfully."
  end

  test "member can not delete nugget" do
    sign_out @user
    @lead = users(:member)
    sign_in @member
    @nugget = Nugget.first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "admin can publish a nugget" do
    @nugget = Nugget.where(published: false).first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    assert_selector "button#publish-button"
  end

  test "lead can not publish a nugget" do
    sign_out @user
    @lead = users(:lead)
    sign_in @lead
    @nugget = Nugget.where(published: false, user: @lead).first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    assert_no_selector "button#publish-button"
  end

  test "member can not publish a nugget" do
    sign_out @user
    @member = users(:member)
    sign_in @member
    @nugget = Nugget.first
    visit nugget_url(script_name: "/#{@account.id}", id: @nugget.id)
    assert_no_selector "button#publish-button"
  end
end
