require "application_system_test_case"

class EmployeeDocumentsTest < ApplicationSystemTestCase
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
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can see feedback detail page" do
    visit page_url
    feedback = @employee.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Show")
    assert_selector "h3", text: feedback.title
    take_screenshot
  end

  test "can delete a feedback" do
    visit page_url
    feedback = @employee.feedbacks.first
    page.accept_confirm do
      find("li", id: dom_id(feedback)).click_link("Delete")
    end
    assert_no_text feedback.title
    take_screenshot
  end

  test "can not show add feedback when user is deactivated" do
    inactive_employee = users(:inactive)
    visit employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Feedback"
  end

  test "can edit feedback" do
    visit page_url
    feedback = @employee.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Edit")
    title = "Some Random Goal Title Edited"
    fill_in "Title", with: ""
    fill_in "Title", with: title
    fill_in_rich_text_area dom_id(feedback), with: title
    take_screenshot
    click_on "Edit Feedback"
    assert_selector "p.notice", text: "Feedback was successfully updated."
    assert_selector "h3", text: title
    assert_selector "div.trix-content", text: title
    take_screenshot
  end

  test "can not edit feedback with invalid params" do
    visit page_url
    feedback = @employee.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Edit")
    fill_in "Title", with: nil
    click_on "Edit Feedback"
    assert_selector "p.alert", text: "Failed to update. Please try again."
    take_screenshot
  end
end
