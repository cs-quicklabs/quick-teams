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

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Employee Skills"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add and remove skills" do
    visit page_url
    fill_in "search-skills", with: "u"
    find("#add-skill").click
    assert_selector "#employee-skills", text: "Vue"
    first("#remove-skill").click
    assert_no_selector "#employee-skills", text: "Ruby"
  end
end
