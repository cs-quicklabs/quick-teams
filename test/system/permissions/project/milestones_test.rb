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

  test "admin can see project milestones" do
  end

  test "admin can see project milestone details" do
  end

  test "lead can not see project milestone" do
  end

  test "lead can not see project milestone details" do
  end

  test "member can not see project milestone" do
  end

  test "member can not see project milestones details" do
  end

  test "manager can see project milestones" do
  end

  test "manager can see project milestone details" do
  end

  test "manager can not see project milestones for different project" do
  end

  test "manager can not see project milestone details of different project" do
  end
end
