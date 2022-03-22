require "application_system_test_case"

class ProjectSchedulesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:unarchived)
    sign_in @employee
  end

  def page_url
    project_schedules_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Participants"
    assert_text "Add New Participant"
    take_screenshot
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can redirect to employee detail page on participant click" do
    visit page_url
    participant = @project.participants.first
    click_on "#{participant.first_name} #{participant.last_name}"
    assert_selector "h1", text: "#{participant.first_name} #{participant.last_name}"
  end

  test "can add new participant" do
    visit page_url
    name = "#{users(:abram).first_name + " " + users(:abram).last_name}"
    select name, from: "schedule_user_id"
    fill_in "schedule_starts_at", with: Time.now
    fill_in "schedule_ends_at", with: Time.now.next_month
    fill_in "schedule_occupancy", with: 100
    click_on "Add Participant"
    assert_selector "div#project-participants", text: name
    take_screenshot
  end

  test "can not add participant with empty params" do
    visit page_url
    click_on "Add Participant"
    assert_selector "div#error_explanation", text: "User must exist"
    assert_selector "div#error_explanation", text: "User can't be blank"
    assert_selector "div#error_explanation", text: "Ends at can't be blank"
    assert_selector "div#error_explanation", text: "Occupancy can't be blank"
    assert_selector "div#error_explanation", text: "Occupancy is not a number"
    assert_selector "div#error_explanation", text: "Occupancy should be less than equal to 100%"
    take_screenshot
  end

  test "can delete a participant" do
    visit page_url

    schedule = @project.schedules.first
    display_name = schedule.user.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find("turbo-frame", id: dom_id(schedule)).click_link("Delete")
    end
    within "#project-participants" do
      assert_no_text display_name
    end
  end

  test "can edit a participant" do
    visit page_url
    schedule = @project.schedules.first
    display_name = schedule.user.decorate.display_name
    assert_text display_name
    find("turbo-frame", id: dom_id(schedule)).click_link("Edit")
    take_screenshot
    within "#project-participants" do
      fill_in "schedule_occupancy", with: ""
      fill_in "schedule_occupancy", with: 79
      click_on "Save"
      take_screenshot
      assert_text display_name
      assert_text "79% occupied"
      assert_no_text "Save"
    end
    take_screenshot
  end

  test "can not edit participant with invalid params" do
    visit page_url
    schedule = @project.schedules.first
    display_name = schedule.user.decorate.display_name
    assert_text display_name
    find("turbo-frame", id: dom_id(schedule)).click_link("Edit")
    within "#project-participants" do
      fill_in "schedule_occupancy", with: 790
      fill_in "schedule_starts_at", with: Time.now.next_month
      fill_in "schedule_ends_at", with: Time.now
      click_on "Save"
      assert_text "Occupancy should be less than equal to 100%"
      assert_text "Ends at cannot be before the start date"
      take_screenshot
    end
  end

  test "can not show add participant when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Participant"
  end
end
