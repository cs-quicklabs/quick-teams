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

  test "admin can see and edit about the project " do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_text "Edit"
  end

  test "admin can add and remove project observer" do
    sign_out @employee
    @employee = users(:super)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    within "#add-observers" do
      assert_text "Project Observers"
      assert_text "Search to add new observer"
      within "#project-observers" do
        assert_text "Remove"
      end
    end
  end

  test "project manager can see and edit about the project " do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_text "Edit"
  end

  test "project manager can not add and remove project observer" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:managed)
    sign_in @employee
    visit page_url
    within "#add-observers" do
      assert_text "Project Observers"
      assert_no_text "Search to add new observer"
      within "#project-observers" do
        assert_no_text "Remove"
      end
    end
  end

  test "lead can not edit the project detail " do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_no_text "Edit"
  end

  test "lead can not add and remove project observer" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_no_selector "#add-observers"
  end

  test "memeber can not edit the projet detail" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_no_text "Edit"
  end

  test "member can not add and remove project observer" do
    sign_out @employee
    @employee = users(:member)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_no_selector "#add-observers"
  end

  test "project observer can see and edit about the project" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_text "Edit"
  end

  test "project observer can not remove and add project observer" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    within "#add-observers" do
      assert_text "Project Observers"
      assert_no_text "Search to add new observer"
      within "#project-observers" do
        assert_no_text "Remove"
      end
    end
  end
end
