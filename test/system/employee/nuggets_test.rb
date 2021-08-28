require "application_system_test_case"

class EmployeeNuggetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:lead)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @nuggets = @employee.nuggets
    @nugget = @nuggets.first
    sign_in @employee
  end

  def page_url
    employee_nuggets_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def show_page_url
    employee_nugget_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @nugget.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_selector "div#employee-tabs", text: "Nuggets"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can filter nuggets based on skills" do
  end

  test "can see published nugget details" do
  end

  test "can not access unpublished nuggets" do
  end
end
