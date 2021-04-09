require "application_system_test_case"

class TeamTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:unarchived)
    sign_in @employee
  end

  def page_url
    project_participants_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Participants"
    assert_text "Add New Participant"
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
    select "#{users(:abram).first_name + " " + users(:abram).last_name}", from: "schedule_user_id"
    fill_in "schedule_starts_at", with: Time.now
    fill_in "schedule_ends_at", with: Time.now.next_month
    fill_in "schedule_occupancy", with: 100
    click_on "Add Participant"
    take_screenshot
    assert_selector "p.notice", text: "Participant was added successfully."
  end

  test "can not add participant with empty params" do
    visit page_url
    click_on "Add Participant"
    take_screenshot
    assert_text "User must exist"
    assert_text "User can't be blank"
    assert_text "Starts at can't be blank"
    assert_text "Ends at can't be blank"
    assert_text "Occupancy can't be blank"
    assert_text "Occupancy is not a number"
    assert_text "Occupancy should be less than equal to 100%"
  end

  test "can delete a participant" do
    visit page_url
    text = "#{@project.participants.first.first_name} #{@project.participants.first.last_name}"
    assert_text text
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/turbo-frame/li/div/div/div[2]/div[2]/div/div[2]/a").click
    within "#project-participants" do
      assert_no_text text
    end
    assert_selector "p.notice", text: "Participant was removed successfully."
  end

  test "can edit a participant" do
    visit page_url
    assert_text "#{@project.participants.first.first_name} #{@project.participants.first.last_name}"
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/turbo-frame/li/div/div/div[2]/div[2]/div/div[1]/a").click
    take_screenshot
    within "#project-participants" do
      fill_in "schedule_occupancy", with: ""
      fill_in "schedule_occupancy", with: 79
      click_on "Save"
      take_screenshot
      assert_text "#{@project.participants.first.first_name} #{@project.participants.first.last_name}"
      assert_text "79% occupied"
      assert_no_text "Save"
    end
  end

  test "can not edit participant with invalid params" do
    visit page_url
    assert_text "#{@project.participants.first.first_name} #{@project.participants.first.last_name}"
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/turbo-frame/li/div/div/div[2]/div[2]/div/div[1]/a").click
    take_screenshot
    within "#project-participants" do
      fill_in "schedule_occupancy", with: 790
      fill_in "schedule_starts_at", with: Time.now.next_month
      fill_in "schedule_ends_at", with: Time.now
      click_on "Save"
      take_screenshot
      assert_text "Occupancy should be less than equal to 100%"
      assert_text "Ends at cannot be before the start date"
    end
  end

  test "can not show add participant when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Participant"
  end
end
