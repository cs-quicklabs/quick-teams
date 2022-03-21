require "application_system_test_case"
require "nokogiri"

class EmployeeScheduleTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

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
    assert_text "Employee Schedules"
    assert_text "Schedule For New Project"
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
    name = "#{projects(:two).name}"
    select name, from: "schedule_project_id"
    fill_in "schedule_starts_at", with: Time.now
    fill_in "schedule_ends_at", with: Time.now.next_month
    fill_in "schedule_occupancy", with: 100
    assert_emails 1 do
      click_on "Add Schedule"
      sleep(0.5)
    end
    assert_selector "div#project-participants", text: name
    take_screenshot
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.body.to_s)
    link = doc.css("a").first.values.first
    visit link
    assert_text "Employee Schedules"
  end

  test "can not add schedule with empty params" do
    visit page_url
    click_on "Add Schedule"
    take_screenshot
    assert_selector "div#error_explanation", text: "Project must exist"
    assert_selector "div#error_explanation", text: "Project can't be blank"
    assert_selector "div#error_explanation", text: "Ends at can't be blank"
    assert_selector "div#error_explanation", text: "Occupancy can't be blank"
    assert_selector "div#error_explanation", text: "Occupancy is not a number"
    assert_selector "div#error_explanation", text: "Occupancy should be less than equal to 100%"
  end

  test "can delete a schedule" do
    visit page_url
    schedule = @employee.schedules.first
    display_name = schedule.project.name
    assert_text display_name
    page.accept_confirm do
      find("turbo-frame", id: dom_id(schedule)).click_link("Delete")
    end
    within "#project-participants" do
      assert_no_text display_name
    end
  end

  test "can edit a schedule" do
    visit page_url
    schedule = @employee.schedules.first
    display_name = schedule.project.name
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

  test "can not edit schedule with invalid params" do
    visit page_url
    schedule = @employee.schedules.first
    display_name = schedule.project.name
    assert_text display_name
    find("turbo-frame", id: dom_id(schedule)).click_link("Edit")
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
