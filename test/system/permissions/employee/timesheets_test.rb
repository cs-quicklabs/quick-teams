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

  test "admin can see timesheets for other employee" do
    sign_out @employee
    @admin = users(:super)
    sign_in @admin
    @employee = users(:member)
    visit page_url
    assert_selector "div#employee-tabs", text: "Timesheets"
    assert_selector "div#stats"
    @employee.timesheets.each do |timesheet|
      assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "admin can see his own timesheets" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Timesheets"
    assert_selector "form#new_timesheet"
    @employee.timesheets.each do |timesheet|
       assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "lead can see his timesheets" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Timesheets"
    @employee.timesheets.each do |timesheet|
       assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "lead can see his subordiates timesheet" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit subordinate_page_url
    assert_selector "div#employee-tabs", text: "Timesheets"
    @employee.timesheets.each do |timesheet|
       assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_no_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "lead can not see someone elseses timesheet" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "Timesheets"
  end

  test "member can see his timesheet" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Timesheets"
    @employee.timesheets.each do |timesheet|
       assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_no_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "member can not see someone elses timesheet" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
    assert_selector "div#employee-tabs", text: "Timesheets"
  end
end
