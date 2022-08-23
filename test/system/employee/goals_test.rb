require "application_system_test_case"
require "nokogiri"

class EmployeeGoalsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @actor = users(:actor)
    @account = @actor.account
    ActsAsTenant.current_tenant = @account
    @employee = users(:regular)
    sign_in @actor
  end

  def page_url
    employee_goals_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.decorate.display_name}"
    assert_text "Add New Goal"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new goal" do
    visit page_url
    title = "Some Random Goal Title"
    fill_in "Title", with: title
    fill_in "goal_deadline", with: Time.now
    fill_in_rich_text_area "new_goal", with: "This is some goal"
    assert_emails 1 do
      click_on "Add Goal"
      sleep(1)
    end
    assert_selector "tbody#goals", text: title
    take_screenshot
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.body.to_s)
    link = doc.css("a").first.values.first
    visit link
    assert_selector "h3", text: title
  end

  test "can not add goal with empty details" do
    visit page_url
    click_on "Add Goal"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Deadline can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can see goal detail page" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link(goal.title)
    assert_selector "h3", text: goal.title
    take_screenshot
  end

  test "can delete a goal" do
    visit page_url
    goal = @employee.goals.first
    page.accept_confirm do
      find("tr", id: dom_id(goal)).click_link("Delete")
    end
    assert_no_text goal.title
    take_screenshot
  end

  test "can not show add goal when employee is inactive" do
    inactive_employee = users(:inactive)
    visit employee_goals_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Goal"
    take_screenshot
  end

  test "can edit goal" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link("Edit")
    title = "Some Random Goal Title Edited"
    fill_in "", with: title
    fill_in "Title", with: title
    fill_in "goal_deadline", with: Time.now
    fill_in_rich_text_area dom_id(goal), with: "This is some goal Edited"
    take_screenshot
    click_on "Edit Goal"
    assert_selector "p.notice", text: "Goal was successfully updated."
    assert_selector "h3", text: title
    assert_selector "div.trix-content", text: "This is some goal Edited"
    take_screenshot
  end

  test "can not edit goal with invalid params" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link("Edit")
    fill_in "Title", with: nil
    click_on "Edit Goal"
    assert_selector "p.alert", text: "Failed to update. Please try again."
    take_screenshot
  end

  test "can comment on goal" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link(goal.title)
    fill_in "comment", with: "This is a comment"
    assert_emails 1 do
      click_on "Comment"
      sleep(0.5)
    end
    assert_selector "ul#comments", text: "This is a comment"
    assert_text "Edit"
    assert_text "Delete"
    take_screenshot
  end

  test "can complete goal" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link(goal.title)
    fill_in "comment", with: "This is completed"
    click_on "option-menu-button"
    click_on "and mark Completed"
    assert_selector "ul#comments", text: "This is completed"
    assert_selector "p", text: "This goal was marked as complete."
    take_screenshot
  end

  test "can miss goal" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link(goal.title)
    fill_in "comment", with: "This is missed"
    click_on "option-menu-button"
    click_on "and mark Missed"
    assert_selector "ul#comments", text: "This is missed"
    assert_selector "p", text: "Unfortunately, this goal was missed and was not completed."
    take_screenshot
  end

  test "can discard goal" do
    visit page_url
    goal = @employee.goals.first
    find("tr", id: dom_id(goal)).click_link(goal.title)
    fill_in "comment", with: "This is discarded"
    click_on "option-menu-button"
    click_on "and mark Discarded"
    assert_selector "ul#comments", text: "This is discarded"
    assert_selector "p", text: "This goal was discarded."
    take_screenshot
  end
end
