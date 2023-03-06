require "application_system_test_case"

class ProjectTimesheetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_timesheets_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project timesheets" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Timesheets"
    assert_selector "div#timesheet-stats"
    assert_selector "div#timesheet-list"
  end

  test "lead can not see project timesheets" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timesheets"
  end

  test "member can not see project timesheets" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timesheets"
  end

  test "manager can see project timesheets" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Timesheets"
    assert_selector "div#timesheet-stats"
    assert_selector "div#timesheet-list"
    @employee.timesheets.each do |timesheet|
      assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_no_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "manager can not see project timesheets of other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    assert_no_selector "div#project-tabs", text: "Timesheets"
  end

  test "observer can see project timesheets" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Timesheets"
    assert_selector "div#timesheet-stats"
    assert_selector "div#timesheet-list"
    @employee.timesheets.each do |timesheet|
      assert_selector "div##{dom_id(timesheet)}", text: "Edit"
      assert_no_selector "div##{dom_id(timesheet)}", text: "Delete"
    end
  end

  test "observer can not see project timesheets of other projects" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:managed)
    sign_in @employee
    assert_no_selector "div#project-tabs", text: "Timesheets"
  end
end
