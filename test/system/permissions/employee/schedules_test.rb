require "application_system_test_case"

class EmployeeScheduleTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_schedules_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see schedule" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_selector "form#new_schedule"
    @employee.schedules.each do |schedule|
      assert_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
      assert_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    end
  end

  test "member can see his schedule" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_no_selector "form#new_schedule"
    @employee.schedules.each do |schedule|
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    end
  end

  test "member can not see someone elsees schedule" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_no_selector "form#new_schedule"
  end

  test "lead can see his schedule" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_no_selector "form#new_schedule"
    @employee.schedules.each do |schedule|
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    end
  end

  test "lead can see schedule of his subordinates" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_no_selector "form#new_schedule"
    @employee.schedules.each do |schedule|
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Edit"
      assert_no_selector "turbo-frame##{dom_id(schedule)}", text: "Delete"
    end
  end

  test "lead can not see schedule of other employees" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "Schedules"
    assert_no_selector "form#new_schedule"
  end
end
