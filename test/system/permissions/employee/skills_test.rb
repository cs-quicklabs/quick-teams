require "application_system_test_case"

class EmployeeSkillsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_skills_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see skills" do
  end

  test "lead can see his skills" do
  end

  test "lead can see his subordinate skills" do
  end

  test "lead can not see skills of other employee" do
  end

  test "member can see his skills " do
  end

  test "member can not see someone elsees skills" do
  end
end
