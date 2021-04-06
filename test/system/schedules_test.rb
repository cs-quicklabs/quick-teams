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
    find(:xpath, "/html/body/div[3]/div/div[1]/div/div/nav/div/div/a[2]").click
    assert_current_path("/#{@account.id}/schedule?job=#{jobs(:developer).id}")
  end

  test "can navigate to employee page" do
    visit page_url
    find(:xpath, "/html/body/div[3]/div/div[2]/table/tbody/tr[1]/td[1]/div/div[2]/a/div[1]").click
    within "#employee-header" do
      assert_selector "a", text: "Deactivate"
    end
  end
end
