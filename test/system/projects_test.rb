require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
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
    within "#project-header" do
      assert_text "Archive"
    end
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
    assert_selector "p.notice", text: "Project was successfully created."
  end

  test "can not create with empty Name Discipline manager" do
    visit page_url
    click_on "New Project"
    assert_selector "h1", text: "Create New Project"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Create New Project"
    assert_text "Discipline must exist"
    assert_text "Name can't be blank"
  end

  test "can edit a project" do
    visit page_url
    click_on "#{@project.name} in #{@project.discipline.name}"
    within "#project-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Project"
    fill_in "Project Name", with: "Awesome"
    select disciplines(:hr).name, from: "project_discipline_id"
    select "#{users(:actor).first_name} #{users(:actor).last_name}", from: "project_manager_id"
    click_on "Save"
    assert_selector "p.notice", text: "Project was successfully updated."
  end

  test "can not edit a project with invalid name" do
    visit page_url
    click_on "#{@project.name} in #{@project.discipline.name}"
    within "#project-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Project"
    fill_in "Project Name", with: ""
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can archive a project" do
    visit page_url
    click_on "#{@project.name} in #{@project.discipline.name}"
    within "#project-header" do
      click_on "Archive"
    end
    take_screenshot
    assert_text "Project has been archived."
    assert_selector "h1", text: "Archived Projects"
  end

  test "can unarchive a project" do
    visit archived_projects_url(script_name: "/#{@account.id}")
    project = projects(:archived)
    click_on "#{project.name} in #{project.discipline.name}"
    within "#project-header" do
      click_on "Restore"
    end
    take_screenshot
    assert_selector "p.notice", text: "Project has been restored."
  end

  test "can see project archives and restore project" do
    visit archived_projects_url(script_name: "/#{@account.id}")
    page.first(:link, "Restore").click
    assert_selector "p.notice", text: "Project has been restored."
  end
end
