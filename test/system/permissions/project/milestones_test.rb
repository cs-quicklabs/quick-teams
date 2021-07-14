require "application_system_test_case"

class ProjectMilestonesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_milestones_url(script_name: "/#{@account.id}", project_id: @project.id)
  end
end
