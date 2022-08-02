require "application_system_test_case"

class ProjectAboutTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:one)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_about_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit projects if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@project.name}"
    assert_text "About"
  end

  test "can edit the Project About" do
    visit page_url
    find("turbo-frame").click_link("Edit")
    fill_in "project_about", with: 'This is test description about project'
    click_on "Save"
    sleep(0.5)
    assert_text "This is test description about project"
    take_screenshot
  end

  test "can not visit project if not logged in" do
    sign_out @employee

    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

end
