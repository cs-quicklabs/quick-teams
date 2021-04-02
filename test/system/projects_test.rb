require "application_system_test_case"

class ProjectTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @user
  end

  def page_url
    projects_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Projects"
    assert_text "New Project"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show project detail page" do
    visit page_url
    click_on "#{@project.name} in #{@project.discipline.name}"
    assert_text "Add New Participant"
    take_screenshot
  end

  test "can create a new project" do
    visit page_url
    click_on "New Project"
    fill_in "Project Name", with: "Awesome"
    fill_in "Description", with: "This is a sample Project Description"
    select disciplines(:engineering).name, from: "project_discipline_id"
    click_on "Save"
    take_screenshot
    assert_text "Project was successfully created."
  end

  test "can not create with empty Name Discipline manager" do
    visit page_url
    click_on "New Project"
    assert_text "Create New Project"
    click_on "Save"
    take_screenshot
    assert_text "Create New Project"
    assert_text "Discipline must exist"
    assert_text "Name can't be blank"
  end

  test "can edit a project" do
  end

  test "can archive a project" do
  end

  test "can unarchive a project" do
  end

  test "can see project archives and restore project" do
  end
end
