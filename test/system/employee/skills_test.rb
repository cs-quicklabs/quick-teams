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

  def show_skills_url
    employee_show_skills_url(script_name: "/#{@account.id}", employee_id: @employee.id)
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
  test "can visit show all skills if logged in" do
    visit page_url
    find("div", id: "show-skills").click_link(" or show all skills")
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}'s skills" 
  end
  test "can add and remove skills via checkbox" do
    visit show_skills_url
      skill = Skill.first

    if find("li", id: dom_id(skill)).checked
      find("li", id: dom_id(skill)).uncheck
       @employee.reload
      aseert @employee.skills.include?(skill), false
    else
      find("li", id: dom_id(skill)).check
      @employee.reload
      aseert @employee.skills.include?(skill), true
    end
    take_screenshot
  end
  test "back button should return to employee skills" do
    visit show_skills_url
    click_on "Back"
    assert_text "Employee Skills", true
    take_screenshot   
  end
  

end
