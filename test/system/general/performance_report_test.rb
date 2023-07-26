require "application_system_test_case"

class EmployeesPerformanceReportTest < ApplicationSystemTestCase
  setup do
    @user = users(:super)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @kpis = survey_attempts(:kpi)
    @survey = Survey::Survey.where(survey_type: "kpi").where(survey_for: "user").first
    sign_in @user
  end

  def page_url
    reports_url(script_name: "/#{@account.id}")
  end

  def reports_page_url
    kpis_reports_url(script_name: "/#{@account.id}", survey_type: @survey.id, participant_id: @kpis.participant.id, from_date: Date.today - 1.day, to_date: Date.today + 1.day)
  end

  test "can visit the employee kpi's reports page and download pdf" do
    visit reports_page_url
    click_on "Search"
    assert_text "Download PDF"
    click_on "Download PDF"
  end

  test "can view comments box" do
    visit reports_page_url
    click_on "Search"
    assert_text "Download PDF"
    sleep(0.5)
    click_on "View"
    assert_text "Comment:"
    click_on "Close"
    assert_text "Employee KPIs Report"
    take_screenshot
  end

  test "can not see Download PDF button if the employee is not selected" do
    visit page_url
    assert_selector "h3", text: "EMPLOYEES"
    click_on "Employees KPIs Report"
    assert_text "Employee KPIs Report"
    click_on "Search"
    assert_no_text "Download PDF"
  end
end
