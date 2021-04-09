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

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Team Members"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can navigate to employee page" do
    visit page_url
    subordinate = @employee.subordinates.first
    click_on "#{subordinate.first_name} #{subordinate.last_name}"
    assert_selector "h1", text: "#{subordinate.first_name} #{subordinate.last_name}"
  end
end
