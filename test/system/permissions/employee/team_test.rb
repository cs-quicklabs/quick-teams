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
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "lead can see his team" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "lead can see his subordinate team" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "lead can not see team of other employee" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "member can  see team " do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "project manager can see his team if he is not lead" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "project manager can see his project participant team" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "project manager can not see team of other employee" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    # manager is redirected to his own profile
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project observer can see his team if he is not lead" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "project observer can see his project participant team" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:actor)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Team"
  end

  test "project observer can not see team of other employee" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    # manager is redirected to his own profile
    assert_selector "h1", text: @observer.decorate.display_name
  end
end
