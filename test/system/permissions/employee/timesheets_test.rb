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
end
