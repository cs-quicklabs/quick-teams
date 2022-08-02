require "application_system_test_case"

class EmployeeInformationTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_about_index_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see and edit the applicant info" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_text "Experience"
    assert_text "About"
    assert_text "Cv"
  end

  test "project manager can see and edit the applicant info" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_text "Experience"
    assert_text "About"
    assert_text "Cv"
  end

  test "team lead can not see and edit the applicant info" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_text "Experience"
    assert_text "About"
    assert_text "Cv"
  end

  test "memeber can not see and edit the applicant info" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_text "Experience"
    assert_text "About"
    assert_text "Cv"
  end
end
