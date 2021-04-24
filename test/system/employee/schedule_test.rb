require "application_system_test_case"

class EmployeeScheduleTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_schedules_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Project Participants"
    assert_text "Schedule for new project"
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can redirect to employee detail page on project click" do
    visit page_url
    project = @employee.projects.first
    click_on "#{project.name}"
    assert_selector "h1", text: "#{project.name}"
  end

  test "can add new schedule" do
    visit page_url
    select "#{projects(:one).name}", from: "schedule_project_id"
    fill_in "schedule_starts_at", with: Time.now
    fill_in "schedule_ends_at", with: Time.now.next_month
    fill_in "schedule_occupancy", with: 100
    click_on "Add Schedule"
    take_screenshot
    assert_selector "p.notice", text: "Schedule was added successfully."
  end

  test "can not add schedule with empty params" do
    visit page_url
    click_on "Add Schedule"
    take_screenshot
    assert_text "Project must exist"
    assert_text "Project can't be blank"
    assert_text "Starts at can't be blank"
    assert_text "Ends at can't be blank"
    assert_text "Occupancy can't be blank"
    assert_text "Occupancy is not a number"
    assert_text "Occupancy should be less than equal to 100%"
  end

  test "can delete a schedule" do
    visit page_url
    text = "#{@employee.projects.first.name}"
    assert_text text
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/turbo-frame/li/div/div/div[2]/div[2]/div/div[2]/a").click
    within "#project-participants" do
      assert_no_text text
    end
    assert_selector "p.notice", text: "Schedule was removed successfully."
  end

  test "can edit a schedule" do
    visit page_url
    assert_text "#{@employee.projects.first.name}"
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/turbo-frame/li/div/div/div[2]/div[2]/div/div[1]/a").click
    take_screenshot
    within "#project-participants" do
      fill_in "schedule_occupancy", with: ""
      fill_in "schedule_occupancy", with: 79
      click_on "Save"
      take_screenshot
      assert_text "#{@employee.projects.first.name}"
      assert_text "79% occupied"
      assert_no_text "Save"
    end
  end

  test "can not edit schedule with invalid params" do
    visit page_url
    assert_text "#{@employee.projects.first.name}"
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

  test "can not show add schedule when employee is inactive" do
    inactive_employee = users(:inactive)
    visit employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Schedule for new project"
  end
end
