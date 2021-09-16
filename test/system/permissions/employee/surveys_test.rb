require "application_system_test_case"

class EmployeeSurveysTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_surveys_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see surveys" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    take_screenshot
    survey = survey_surveys(:one)
    assert_equal survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "Surveys"
  end
end
