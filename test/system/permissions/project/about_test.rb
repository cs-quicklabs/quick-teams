require "application_system_test_case"

class ProjectAboutTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:managed)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_about_index_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see and edit about the project" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_text "About"
  end

  test "project manager can see and edit about the project" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_text "About"
  end

end
