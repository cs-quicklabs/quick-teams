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

end
