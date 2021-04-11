require "application_system_test_case"

class SearchTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    search_url(script_name: "/#{@account.id}")
  end

  test "can search for employees" do
    visit page_url
    fill_in "Search People", with: "Mayank"
      assert_not_nil assigns(:employee)
      assert_equal employees(:rails).first_name, assigns(:employee).first_name
      assert_valid assigns(:employee)
      assert_redirected_to :action => 'show'
  end

  test "can search for projects" do
    visit page_url
    fill_in "Search People", with: "Test Project"
      assert_not_nil assigns(:project)
      assert_equal projects(:rails).name, assigns(:project).name
      assert_valid assigns(:project)
      assert_redirected_to :action => 'show'
  end

  # test "can not search deactivated employess" do
  # end

  # test "can not search archived projects" do
  # end
end
