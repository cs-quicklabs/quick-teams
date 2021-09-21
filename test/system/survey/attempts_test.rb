require "application_system_test_case"

class AttemptsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    @survey = survey_surveys(:one)
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    survey_attempts_url(script_name: "/#{@account.id}", survey_id: @survey.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: @survey.name
    assert_selector "div#survey-tabs", text: "Attempts"
    assert_selector "div#assignees"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can attempt a survey" do
    visit page_url
    click_on "Attempt"
    take_screenshot
    find(:select, id: "survey_attempt_participant_id").find(:xpath, "option[3]").select_option
    click_on "Start"
    take_screenshot
  end

  test "can view  attempt" do
    visit page_url
    take_screenshot
    if @survey.attempts > 0
      attempt = @survey.attempts.first
      find("tr", id: dom_id(attempt)).click_link("View")
      assert_selector "h1", text: @survey.name
      assert_selector "p", text: "Participant"
      assert_selector "h3", text: "Score"
    end
    take_screenshot
  end

  test "can delete attempt" do
    visit page_url
    take_screenshot
    if @survey.attempts > 0
      attempt = @survey.attempts.first
      page.accept_confirm do
        find("tr", id: dom_id(attempt)).click_link("Delete")
      end
      assert_not_selector dom_id(attempt)
    end
    take_screenshot
  end
end
