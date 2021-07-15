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

  test "admin can see project timesheets" do
  end

  test "lead can not see project timesheets" do
  end

  test "member can not see project timesheets" do
  end

  test "manager can see project timesheets" do
  end

  test "manager can not see project timesheets of other projects" do
  end
end
