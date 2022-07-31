require "application_system_test_case"

class ProjectClientsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:managed)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_clients_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see and add clients" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_text "Add New Client"
  end

  test "project manager can see and add clients" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_text "Add New Client"
  end

  test "team lead can not see and add clients" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_text "Add New Client"
  end

  test "memeber can not see and add clients" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_text "Add New Client"
  end
end
