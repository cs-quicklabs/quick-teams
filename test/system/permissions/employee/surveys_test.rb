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

  test "admin can see surveys" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    take_screenshot
    survey = survey_surveys(:one)
    assert_equal survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "Surveys"
  end

  test "can not show index if not logged in" do
    sign_out @user
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
  end

  test "can view  attempt" do
    visit page_url
    take_screenshot
    @attempt = survey_attempts(:one)
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
    take_screenshot
    @attempt = survey_attempts(:one)
    if @attempt
      page.accept_confirm do
        find("tr", id: dom_id(@attempt)).click_link("Delete")
      end
      assert_no_selector dom_id(@attempt), text: @attempt.survey
    end
    take_screenshot
  end
end
