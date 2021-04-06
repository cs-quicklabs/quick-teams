require "application_system_test_case"

class FeedbacksTest < ApplicationSystemTestCase
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
  end

  test "can not add feedback with empty details" do
    visit page_url
    click_on "Add Feedback"
    assert_text "Title can't be blank"
    assert_text "Body can't be blank"
  end

  test "can see feedback detail page" do
  end

  test "can delete a feedback" do
  end
end
