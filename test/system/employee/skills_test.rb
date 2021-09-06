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
    find("div", id: "show-skills").click_link("or show all skills")
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}'s skills"
  end

  test "can add and remove skills via checkbox" do
    visit show_skills_url
    skill = @employee.skills.first

    if skill
      find(:css, id: dom_id(skill)).set(false)
      sleep(0.1)
      @employee.reload
      assert_equal @employee.skills.include?(skill), false
      take_screenshot
    end

    skill = Skill.where.not(id: @employee.skill_ids).first
    if skill
      find(:css, id: dom_id(skill)).set(true)
      sleep(0.1)
      @employee.reload
      assert_equal @employee.skills.include?(skill), true
      take_screenshot
    end
  end

  test "back button should return to employee skills" do
    visit show_skills_url
    click_on "Back"
    assert_current_path(page_url)

    take_screenshot
  end
end
