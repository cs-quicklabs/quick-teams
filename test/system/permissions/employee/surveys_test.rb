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

  test "lead can see his surveyss" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "surveys"
  end

  test "lead can see his subordiates surveys" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit subordinate_page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "surveys"
  end

  test "lead can not see someone elseses surveys" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "surveys"
  end

  test "member can see his surveys" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "surveys"
  end

  test "member can not see someone elses surveys" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @member.decorate.display_name
    assert_selector "div#employee-tabs", text: "surveys"
  end
end
