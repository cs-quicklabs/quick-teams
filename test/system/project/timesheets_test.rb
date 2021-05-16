require "application_system_test_case"

class ProjectTimesheetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_timesheets_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "p", text: "Top Contributors"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can see stats" do
    travel_to "2021-04-05".to_date do
      visit page_url
      click_on "Last Week"
      assert_selector "p", text: "Last Week's Performance"
      take_screenshot
      click_on "Last Month"
      assert_selector "p", text: "Last Month's Performance"
      take_screenshot
      click_on "Since Start"
      assert_selector "p", text: "Performance Since Beginning"
      take_screenshot
    end
  end
end
