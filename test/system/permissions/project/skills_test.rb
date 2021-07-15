require "application_system_test_case"

class ProjectSkillsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:one)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_skills_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project skills" do
  end

  test "lead can not see project skills" do
  end

  test "member can not see project skills" do
  end

  test "manager can see project skills" do
  end

  test "manager can not see skills of other projects" do
  end
end
