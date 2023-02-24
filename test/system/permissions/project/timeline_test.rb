require "application_system_test_case"

class ProjectTimelineTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_timeline_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project timeline" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Timeline"
  end

  test "lead can not see project timeline" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end

  test "member can not see project timeline" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end

  test "manager can not see project timeline" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end

  test "observer can not see project timeline" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Timeline"
  end
end
