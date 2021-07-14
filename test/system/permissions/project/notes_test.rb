require "application_system_test_case"

class ProjectNotesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_notes_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project notes with edit buttons" do
  end

  test "lead can not see project notes" do
  end

  test "member can not see project notes" do
  end

  test "manager can see create project note" do
  end

  test "manager can see edit button for his notes" do
  end

  test "manager can not see edit button for someone elses notes" do
  end

  test "manger can not see notes other than his project notes" do
  end
end
