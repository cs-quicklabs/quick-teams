require "application_system_test_case"

class EmployeesNoProjectReportTest < ApplicationSystemTestCase
  setup do
    @user = users(:super)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @schedule = schedules(:nine)
    
    sign_in @user
  end

  def page_url
    no_projects_schedules_reports_url(script_name: "/#{@account.id}/")
  end

  test "can visit the employees with no project reports page" do
    visit page_url
    assert_text "Employees with no projects"
    assert_text @user.name
    assert_no_text @schedule.user.name
  end

end
