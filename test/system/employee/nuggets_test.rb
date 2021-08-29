require "application_system_test_case"

class EmployeeNuggetsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
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
    @employee.published_nuggets.each do |nugget|
      assert_equal nugget.published, true
    end
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can filter nuggets based on skills" do
    visit page_url
    select skills(:ruby).name, from: "skill_id"
    assert_current_path page_url + "?skill_id=#{skills(:ruby).id}"
  end

  test "can clear the filter" do
    visit page_url
    select skills(:ruby).name, from: "skill_id"
    assert_current_path page_url + "?skill_id=#{skills(:ruby).id}"
    click_on "Clear Filter"
    assert_current_path page_url
  end
end
