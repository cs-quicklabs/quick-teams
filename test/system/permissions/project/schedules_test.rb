require "application_system_test_case"

class ProjectSchedulesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_schedules_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project schedule with edit buttons" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Schedules"
    schedule = @project.schedules.first
    assert_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
    assert_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    assert_selector "div#billable-schedule"
    take_screenshot
  end

  test "lead can not see project schedule" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Schedules"
  end

  test "member can not see project schedule" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Schedules"
  end

  test "manager can see project schedule without edit buttons" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Schedules"
    schedule = @project.schedules.first
    assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
    assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    assert_no_selector "div#billable-schedule"
    take_screenshot
  end

  test "manager can not see project schedule other than his project" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    @project = projects(:one)
    visit page_url
    assert_no_selector "div#project-tabs", text: "Schedules"
  end
end
