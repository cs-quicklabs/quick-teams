require "application_system_test_case"

class ProjectMilestonesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_milestones_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Milestones"
    assert_text "Add New Milestone"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new milestone" do
    visit page_url
    fill_in "Title", with: "Some Random milestone Title"
    fill_in "goal_deadline", with: Time.now
    fill_in_rich_text_area "new_goal", with: "This is some milestone"
    click_on "Add Milestone"
    assert_selector "ul#milestones", text: "Some Random milestone Title"
    take_screenshot
  end

  test "can not add milestone with empty details" do
    visit page_url
    click_on "Add Milestone"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    take_screenshot
  end

  test "can see milestone detail page" do
    visit page_url
    milestone = @project.milestones.first
    find("li", id: dom_id(milestone)).click_link("Show")
    assert_selector "h3", text: milestone.title
    take_screenshot
    click_on "Back"
    assert_text "Add New Milestone"
  end

  test "can delete a milestone" do
    visit page_url
    milestone = @project.milestones.first
    find("li", id: dom_id(milestone)).click_link("Delete")
    assert_no_text milestone.title
    take_screenshot
  end

  test "can not show add milestone when project is archived" do
    archived_project = projects(:archived)
    visit project_milestones_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New milestone"
  end

  test "can edit milestone" do
  end

  test "can comment on milestone" do
  end

  test "can complete milestone" do
  end

  test "can miss milestone" do
  end

  test "can discard milestone" do
  end
end
