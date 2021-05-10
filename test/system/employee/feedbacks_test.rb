require "application_system_test_case"

class EmployeeFeedbacksTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Employee Feedbacks"
    assert_text "Add New Feedback"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new feedback" do
    visit page_url
    fill_in "Title", with: "Some Random Feedback Title"
    fill_in_rich_text_area "new_feedback", with: "This is some feedback"
    click_on "Add Feedback"
    take_screenshot
    assert_selector "ul#feedbacks", text: "Some Random Feedback Title"
  end

  test "can not add feedback with empty details" do
    visit page_url
    click_on "Add Feedback"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    take_screenshot
  end

  test "can see feedback detail page" do
    visit page_url
    feedback = @employee.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Show")
    assert_selector "h3", text: feedback.title
    take_screenshot
    click_on "Back"
    assert_text "Add New Feedback"
  end

  test "can delete a feedback" do
    visit page_url
    feedback = @employee.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Delete")
    assert_no_text feedback.title
    take_screenshot
  end

  test "can not show add feedback when user is deactivated" do
    inactive_employee = users(:inactive)
    visit employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Feedback"
  end
end
