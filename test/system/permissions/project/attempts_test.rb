require "application_system_test_case"

class ProjectSurveyAttemptsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def attempts_url
    project_surveys_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def attempt_preview_url
    survey_attempt_url(script_name: "/#{@account.id}", survey_id: @attempt.survey.id, id: @attempt.id)
  end

  test "project manager can see all survey attempts for his project" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @project = projects(:managed)
    visit attempts_url
    assert_selector "h1", text: @project.name
    assert_selector "div#project-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "project manager can not see survey attempts for other projects" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @project = projects(:one)
    visit attempts_url
    assert_selector "h1", text: manager.decorate.display_name
  end

  test "project manager can see survey attempts preview of his project" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @project = projects(:managed)
    @attempt = survey_attempts(:one)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "project manager can not see survey attempt preview of other projects" do
    sign_out @employee
    manager = users(:manager)
    sign_in manager
    @project = projects(:one)
    @attempt = survey_attempts(:two)
    visit attempt_preview_url
    assert_selector "h1", text: manager.decorate.display_name
  end

  test "admin can see all survey attempts for all project" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @project = projects(:managed)
    visit attempts_url
    assert_selector "h1", text: @project.name
    assert_selector "div#project-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "admin can see survey attempts preview of all projects" do
    sign_out @employee
    admin = users(:owner)
    sign_in admin
    @project = projects(:managed)
    @attempt = survey_attempts(:one)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "member can not see survey attempts for any project" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @project = projects(:managed)
    visit attempts_url
    assert_selector "h1", text: member.decorate.display_name
  end

  test "member can not see survey attempts preview of any project" do
    sign_out @employee
    member = users(:member)
    sign_in member
    @project = projects(:managed)
    @attempt = survey_attempts(:two)
    visit attempt_preview_url
    assert_selector "h1", text: member.decorate.display_name
  end

  test "lead can not see survey attempts for any project" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @project = projects(:managed)
    visit attempts_url
    assert_selector "h1", text: lead.decorate.display_name
  end

  test "lead can not see survey attempts preview of any project" do
    sign_out @employee
    lead = users(:lead)
    sign_in lead
    @project = projects(:managed)
    @attempt = survey_attempts(:two)
    visit attempt_preview_url
    assert_selector "h1", text: lead.decorate.display_name
  end

  test "lead who is manager can see survey attempts of assigned project" do
    sign_out @employee
    leadmanager = users(:leadmanager)
    sign_in leadmanager
    @project = projects(:leadmanaged)
    visit attempts_url
    assert_selector "h1", text: @project.name
    assert_selector "div#project-tabs", text: "Surveys"
    assert_text "Take a Survey"
  end

  test "lead who is manager can see survey attempt preview of assigned project" do
    sign_out @employee
    leadmanager = users(:leadmanager)
    sign_in leadmanager
    @project = projects(:leadmanaged)
    @attempt = survey_attempts(:three)
    visit attempt_preview_url
    assert_selector "h1", text: leadmanager.decorate.display_name
  end

  test "lead who is manager can not see survey attempts of other project" do
    sign_out @employee
    leadmanager = users(:leadmanager)
    sign_in leadmanager
    @project = projects(:one)
    visit attempts_url
    assert_selector "h1", text: leadmanager.decorate.display_name
  end

  test "lead who is manager can not see survey attempt previews of other project" do
    sign_out @employee
    leadmanager = users(:leadmanager)
    sign_in leadmanager
    @project = projects(:one)
    @attempt = survey_attempts(:two)
    visit attempt_preview_url
    assert_selector "h1", text: leadmanager.decorate.display_name
  end

  #TODO 
  test "project observer can see all survey attempts for his assigned project" do

  end

  #TODO
  test "project observer can not see all survey attempts for other projects" do

  end

  test "project observer can see survey attempts preview of his project" do
    sign_out @employee
    observer = users(:abram)
    sign_in observer
    @project = projects(:one)
    @attempt = survey_attempts(:therteen)
    visit attempt_preview_url
    assert_selector "h3", text: @attempt.survey.name
  end

  test "project observer can not see survey attempt preview of other projects" do
    sign_out @employee
    observer = users(:abram)
    sign_in observer
    @project = projects(:managed)
    @attempt = survey_attempts(:one)
    visit attempt_preview_url
    assert_selector "h1", text: observer.decorate.display_name
  end
end
