require "application_system_test_case"

class SchedulesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
  end

  def page_url
    schedules_url(script_name: "/#{@account.id}")
  end

  test "can visit page if logged in " do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Schedule"
  end

  test "can not visit if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can navigate with jobs menu" do
    visit page_url
    job = jobs(:developer)
    within "nav#menu" do
      find("a", id: dom_id(job)).click
    end

    assert_current_path("/#{@account.id}/schedule?job=#{job.id}")
  end

  test "can navigate to employee page" do
    visit page_url
    user = User.where(account: @account).active.order(:first_name).first
    find("tr", id: dom_id(user)).click_link(user.decorate.display_name)
    within "#employee-header" do
      assert_selector "a", text: "Deactivate"
    end
  end
end
