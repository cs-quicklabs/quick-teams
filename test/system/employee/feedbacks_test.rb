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
    visit page_url
    fill_in "Title", with: "Some Random Feedback Title"
    fill_in_rich_text_area "new_feedback", with: "This is some feedback"
    click_on "Add Feedback"
    take_screenshot
    assert_selector "p.notice", text: "Feedback was added successfully."
    assert_text "Some Random Feedback Title"
  end

  test "can not add feedback with empty details" do
    visit page_url
    click_on "Add Feedback"
    take_screenshot
    assert_text "Title can't be blank"
  end

  test "can see feedback detail page" do
    visit page_url
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/li[1]/div/div[2]/div[3]/a[1]").click
    assert_selector "h3", text: feedbacks(:one).title
    take_screenshot
    click_on "Back"
    assert_text "Add New Feedback"
  end

  test "can delete a feedback" do
    visit page_url
    assert_text feedbacks(:one).title
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/li[1]/div/div[2]/div[3]/a[2]").click
    take_screenshot
    assert_selector "p.notice", text: "Feedback was removed successfully."
    assert_no_text feedbacks(:one).title
  end

  test "can not show add feedback when user is deactivated" do
    inactive_employee = users(:inactive)
    visit employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Feedback"
  end
end
