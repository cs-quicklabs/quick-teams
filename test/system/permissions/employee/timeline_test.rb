require "application_system_test_case"

class EmployeeTimelineTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_timeline_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see timeline" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Timeline"
  end

  test "lead can not see timeline" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end

  test "memeber can not see timeline" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end
end
