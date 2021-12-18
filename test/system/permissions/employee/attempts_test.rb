require "application_system_test_case"

class EmployeeSurveyAttemptsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def attempts_url
    employee_surveys_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def attempt_preview_url
    survey_attempt_url(script_name: "/#{@account.id}", survey_id: @attempt.survey.id, id: @attempt.id)
  end

  test "member can see his own attempts" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit attempts_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "member can not see other's attempts" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @employee = users(:admin)
    visit attempts_url
    assert_selector "h1", text: member.decorate.display_name
  end

  test "member can see his own attempts previews" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @attempt = survey_attempts(:four)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "member can not see other attempt previews" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @attempt = survey_attempts(:five)
    visit attempt_preview_url
    assert_selector "h1", text: member.decorate.display_name
  end

  test "member can not see see attempt previews done for him by others" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @attempt = survey_attempts(:five)
    visit attempt_preview_url
    assert_selector "h1", text: member.decorate.display_name
  end

  test "admin can see his own attempts" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @employee = admin
    visit attempts_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "admin can see other's attempts" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @employee = users(:regular)
    visit attempts_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "admin can see his own attempt previews" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @attempt = survey_attempts(:seven)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "admin can see all attempt previews" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @attempt = survey_attempts(:four)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "lead can see his own attempts" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @employee = lead
    visit attempts_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "lead can not see other's attempts" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @employee = users(:regular)
    visit attempts_url
    assert_selector "h1", text: lead.decorate.display_name
  end

  test "lead can see his own attempts previews" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @attempt = survey_attempts(:eight)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "lead can not see other's attempts previews" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @attempt = survey_attempts(:four)
    visit attempt_preview_url
    assert_selector "h1", text: lead.decorate.display_name
  end

  test "lead can see attempt previews of his subordinates done by someone else" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @employee = users(:subordinate)
    @attempt = survey_attempts(:nine)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "project manager can see his own attempts" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @employee = manager
    visit attempts_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "project manager can see his attempt previews" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @attempt = survey_attempts(:ten)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "project manager can not see other's attempts" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @employee = users(:admin)
    visit attempts_url
    assert_selector "h1", text: manager.decorate.display_name
  end

  test "project manager can not see other's attempts previews" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @attempt = survey_attempts(:eleven)
    visit attempt_preview_url
    assert_selector "h1", text: manager.decorate.display_name
  end

  test "project manager can see attempt previews of his project participants" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @attempt = survey_attempts(:tweleve)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "project manager can not see attempt previews of other project participant" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @attempt = survey_attempts(:eleven)
    visit attempt_preview_url
    assert_selector "h1", text: manager.decorate.display_name
  end
end
