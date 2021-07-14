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
end
