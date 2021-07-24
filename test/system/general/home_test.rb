require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    home_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "p", text: "Recent Activities"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end
end
