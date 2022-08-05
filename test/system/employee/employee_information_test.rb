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

  test "can visit Employee Applicant Information if logged in" do
    visit page_url
    take_screenshot
  end

  test "can edit the Employee Applicant Experience" do
    visit page_url
    find("turbo-frame", id: "experience_user_#{@employee.id}").click_link("Edit")
    fill_in "user_experience", with: "7"
    click_on "Save"
    take_screenshot
    sleep(0.5)
  end

  test "can edit the Employee Applicant About" do
    visit page_url
    find("turbo-frame", id: "about_user_#{@employee.id}").click_link("Edit")
    fill_in "user_about", with: "This is test description about employee"
    click_on "Save"
    take_screenshot
    sleep(0.5)
  end

  test "can edit the Employee Applicant CV" do
    visit page_url
    find("turbo-frame", id: "cv_user_#{@employee.id}").click_link("Edit")
    fill_in "user_cv", with: "www.google.com"
    click_on "Save"
    take_screenshot
    sleep(0.5)
  end

  test "can not visit Employee Applicant Information if not logged in" do
    sign_out @employee

    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end
end
