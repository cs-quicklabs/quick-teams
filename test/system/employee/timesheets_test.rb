require "application_system_test_case"

class EmployeeTimesheetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    employee_timesheets_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def subordinate_page_url
    employee_timesheets_url(script_name: "/#{@account.id}", employee_id: @employee.subordinates.first.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_text "Add New Timesheet"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can see stats for another user" do
    travel_to "2021-04-05".to_date do
      visit subordinate_page_url
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

  test "can add timesheet" do
    visit page_url
    select @employee.projects.first.name, from: "timesheet_project_id"
    fill_in "timesheet_date", with: Time.now
    fill_in "timesheet_description", with: "Worked on some random project"
    fill_in "timesheet_hours", with: 2
    click_on "Add Timesheet"
    assert_selector "tbody#timesheets", text: "Worked on some random project"
  end

  test "can delete timesheet" do
    travel_to "2021-04-05".to_date do
      visit page_url
      timesheet = @employee.timesheets.last_30_days.order(date: :desc).first
      assert_text timesheet.description
      page.accept_confirm do
        find("tr", id: dom_id(timesheet)).click_link("Delete")
      end
      assert_no_selector "tbody#timesheets", text: timesheet.description
    end
  end
end
