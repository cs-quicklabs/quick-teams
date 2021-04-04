require "application_system_test_case"

class EmployeesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employees_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "People"
    assert_text "Add Member"
  end

  test "can not show index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show employee detail page" do
    visit page_url
    click_on "#{@employee.first_name} #{@employee.last_name}"
    within "#employee-header" do
      assert_text "Deactivate"
    end
    take_screenshot
  end

  test "can create a new employee" do
    visit page_url
    click_on "Add Member"
    assert_selector "h1", text: "Add New Employee"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Email", with: "john.doe@crownstack.com"
    select disciplines(:engineering).name, from: "user_discipline_id"
    select jobs(:ios).name, from: "user_job_id"
    select roles(:senior).name, from: "user_role_id"
    select "#{users(:actor).first_name} #{users(:actor).last_name}", from: "user_manager_id"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "User was successfully created."
  end

  test "can not create employee with invalid parmas" do
    visit page_url
    click_on "Add Member"
    assert_selector "h1", text: "Add New Employee"
    click_on "Save"
    take_screenshot
    assert_selector "p.alert", text: "Failed to create user. Please try again."
  end

  test "can edit an employee" do
    visit page_url
    click_on "#{@employee.first_name} #{@employee.last_name}"
    within "#employee-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Employee Details"
    fill_in "First Name", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Email", with: "john.doe@crownstack.com"
    select disciplines(:engineering).name, from: "user_discipline_id"
    select jobs(:ios).name, from: "user_job_id"
    select roles(:senior).name, from: "user_role_id"
    select "#{users(:actor).first_name} #{users(:actor).last_name}", from: "user_manager_id"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "User was successfully updated."
  end

  test "can not edit an employee with empty name" do
    visit page_url
    click_on "#{@employee.first_name} #{@employee.last_name}"
    within "#employee-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Employee Details"
    fill_in "First Name", with: ""
    fill_in "Last Name", with: ""
    fill_in "Email", with: "john.doe@crownstack.com"
    select disciplines(:engineering).name, from: "user_discipline_id"
    select jobs(:ios).name, from: "user_job_id"
    select roles(:senior).name, from: "user_role_id"
    select "#{users(:actor).first_name} #{users(:actor).last_name}", from: "user_manager_id"
    click_on "Save"
    take_screenshot
    assert_text "First name can't be blank"
    assert_text "Last name can't be blank"
  end

  test "can deactivate an employee" do
    visit page_url
    click_on "#{users(:actor).first_name} #{users(:actor).last_name}"
    within "#employee-header" do
      click_on "Deactivate"
    end
    take_screenshot
    assert_selector "p.notice", text: "User has been deactivated."
    assert_selector "h1", text: "Deactivated Users"
  end

  test "can activate an employee" do
    visit deactivated_users_url(script_name: "/#{@account.id}")
    user = users(:inactive)
    click_on "#{user.first_name} #{user.last_name} #{user.job.name}"
    within "#employee-header" do
      click_on "Activate"
    end
    take_screenshot
    assert_selector "p.notice", text: "User has been activated."
  end

  test "can see deactivated users and reactivate" do
    visit deactivated_users_url(script_name: "/#{@account.id}")
    page.first(:link, "Activate").click
    assert_selector "p.notice", text: "User has been activated."
  end
end
