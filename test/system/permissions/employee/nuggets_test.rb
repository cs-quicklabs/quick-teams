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
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Skills"
  end

  test "lead can see his skills" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Skills"
  end

  test "lead can see his subordinate nuggets" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Nuggets"
  end

  test "lead can not see nuggets of other employee" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "Nuggets"
  end

  test "member can see his nuggets " do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Nuggets"
  end

  test "member can not see someone elsees nuggets" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
    assert_selector "div#employee-tabs", text: "Nuggets"
  end
end
