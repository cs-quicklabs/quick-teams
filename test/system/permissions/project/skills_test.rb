require "application_system_test_case"

class ProjectSkillsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:managed)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_skills_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project skills" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "TechStack"
    assert_selector "input#search-skills"
  end

  test "lead can not see project skills" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "TechStack"
    assert_no_selector "input#search-skills"
  end

  test "member can not see project skills" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "TechStack"
    assert_no_selector "input#search-skills"
  end

  test "manager can see project skills" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "TechStack"
    assert_selector "input#search-skills"
  end

  test "manager can not see skills of other projects" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    @project = projects(:one)
    visit page_url
    assert_no_selector "div#project-tabs", text: "TechStack"
    assert_no_selector "input#search-skills"
  end
end
