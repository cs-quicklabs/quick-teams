require "application_system_test_case"

class ProjectFeedbacksTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_feedbacks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project feedbacks with edit buttons" do
  end

  test "lead can not see project feedbacks" do
  end

  test "lead can not see project feedback details" do
  end

  test "member can not see project feedbacks" do
  end

  test "member can not see project feedback details" do
  end

  test "manager can see project feedbacks with edit buttons" do
  end

  test "manage can see project feedback detail page" do
  end

  test "manager can not see feedback from other projects" do
  end

  test "manager can not see feedback details of other project feedbacks" do
  end
end
