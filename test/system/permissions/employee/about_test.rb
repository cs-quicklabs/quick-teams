require "application_system_test_case"

class EmployeeAboutTest < ApplicationSystemTestCase
  setup do
    @actor = users(:super)
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_about_index_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see and edit the applicant info" do
    sign_out @actor
    @actor = users(:super)
    sign_in @actor
    visit page_url
    assert_text "Experience"
    assert_text "About"
    within "#about_user_#{@employee.id}" do
      assert_selector "a", text: "Edit"
    end
  end

  test "project manager can see but can not edit the applicant info" do
    sign_out @actor
    @actor = users(:manager)
    sign_in @actor
    visit page_url
    assert_text "Experience"
    assert_text "About"
    within "#about_user_#{@employee.id}" do
      assert_no_selector "a", text: "Edit"
    end
  end

  test "team lead can see but can not edit the applicant info" do
    sign_out @actor
    @actor = users(:lead)
    @employee = users(:subordinate)
    sign_in @actor
    visit page_url
    assert_text "Experience"
    assert_text "About"
    within "#about_user_#{@employee.id}" do
      assert_no_selector "a", text: "Edit"
    end
  end

  test "memeber can not see and can not edit the applicant info" do
    sign_out @actor
    @actor = users(:member)
    sign_in @actor
    visit page_url
    assert_no_text "Email Address"
  end
end
