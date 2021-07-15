require "application_system_test_case"

class ProjectTodosTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:unarchived)
    sign_in @employee
  end

  def page_url
    project_todos_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project todos" do
  end

  test "lead can not see project todos" do
  end

  test "member can not see project todos" do
  end

  test "manager can see project todos" do
  end

  test "manager can not see project todos of other projects" do
  end
end
