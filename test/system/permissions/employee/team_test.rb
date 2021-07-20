require "application_system_test_case"

class EmployeeTeamTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_team_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see team" do
  end

  test "lead can see his team" do
  end

  test "lead can see his subordinate team" do
  end

  test "lead can not see team of other employee" do
  end

  test "member can not see team " do
  end
end
