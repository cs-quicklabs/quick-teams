require "application_system_test_case"

class EmployeeSurveysTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_surveys_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_selector "div#employee-tabs", text: "Surveys"
  end

  test "can not show index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can attempt a survey" do
    visit page_url
    @survey = @employee.surveys.first
    page.accept_confirm do
      find("li", id: dom_id(@survey)).click_link
    end
    assert_selector "h3", text: @survey.name
    assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
    take_screenshot
    click_on "Preview and Submit"
    fill_in "survey_attempt_comment", with: "This is a comment"
    click_on "Submit"
    take_screenshot
  end

  test "can view  attempt" do
    visit page_url
    @survey = @employee.surveys.first
    page.accept_confirm do
      find("li", id: dom_id(@survey)).click_link
    end
    assert_selector "h3", text: @survey.name
    assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
    click_on "Preview and Submit"
    fill_in "survey_attempt_comment", with: "This is a comment"
    click_on "Submit"
    take_screenshot
    @attempt = @survey.attempts.last
    if @attempt
      find("tr", id: dom_id(@attempt)).click_link(@attempt.survey.name)
      assert_selector "h3", text: @attempt.survey.name
      assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
      assert_selector "h3", text: "Score"
    end
    take_screenshot
  end

  test "can delete attempt" do
    visit page_url
    @survey = @employee.surveys.first
    page.accept_confirm do
      find("li", id: dom_id(@survey)).click_link
    end
    assert_selector "h3", text: @survey.name
    assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
    click_on "Preview and Submit"
    fill_in "survey_attempt_comment", with: "This is a comment"
    click_on "Submit"
    take_screenshot
    @attempt = @survey.attempts.last
    if @attempt
      page.accept_confirm do
        find("tr", id: dom_id(@attempt)).click_link("Delete")
      end
      assert_no_selector dom_id(@attempt), text: @attempt.survey
    end
    take_screenshot
  end
end
