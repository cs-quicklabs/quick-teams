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

  test "admin can add and remove observed project" do
    sign_out @actor
    @actor = users(:super)
    sign_in @actor
    @employee = users(:abram)
    visit page_url
    within "#add-observed-projects" do
      assert_text "Observed Projects"
      assert_text "Search to add project"
      within "#observed-projects" do
        assert_text "Remove"
      end
    end
    take_screenshot
  end

  test "project manager can see but not add and remove observed project" do
    sign_out @actor
    @actor = users(:manager)
    sign_in @actor
    visit page_url
    within "#add-observed-projects" do
      assert_text "Observed Projects"
      assert_no_text "Search to add project"
      within "#observed-projects" do
        assert_no_text "Remove"
      end
    end
    take_screenshot
  end

  test "team lead can see but not add and remove observed project" do
    sign_out @actor
    @actor = users(:lead)
    sign_in @actor
    @employee = users(:subordinate)
    visit page_url
    within "#add-observed-projects" do
      assert_text "Observed Projects"
      assert_no_text "Search to add project"
      within "#observed-projects" do
        assert_no_text "Remove"
      end
    end
    take_screenshot
  end
  test "member can not add and remove observed project" do
    sign_in @actor
    @actor = users(:member)
    sign_in @actor
    visit page_url
    assert_no_selector "#add-observed-projects"
    take_screenshot
  end
end
