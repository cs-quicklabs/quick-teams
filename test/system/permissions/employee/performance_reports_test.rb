require "application_system_test_case"

class EmployeesPerformanceReporstTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    reports_url(script_name: "/#{@account.id}")
  end

  test "admin can see employees Kpi's reports" do
    sign_out @employee
    sign_in users(:super)
    visit page_url
    take_screenshot
    assert_selector "h3", text: "EMPLOYEES"
    assert_text "Employees KPIs Report"
    take_screenshot
  end

  test "Project Manager can not see Reports Download PDF" do
    sign_out @employee
    @user = users(:manager)
    sign_in @user
    assert_no_text "Reports"
  end

  test "Lead can not see Download PDF" do
    sign_out @employee
    @user = users(:lead)
    sign_in @user
    assert_no_text "Reports"
  end

  test "Member can not see Download PDF" do
    sign_out @employee
    @user = users(:member)
    sign_in @user
    assert_no_text "Reports"
  end

  test "Project observer can not see Reports Download PDF" do
    sign_out @employee
    @user = users(:abram)
    sign_in @user
    assert_no_text "Reports"
  end
end
