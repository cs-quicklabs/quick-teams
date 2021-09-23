require "application_system_test_case"

class EmployeeKpisTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @survey = survey_surveys(:two)
    sign_in @employee
  end

  def page_url
    employee_kpis_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def subordinate_page_url
    employee_kpis_url(script_name: "/#{@account.id}", employee_id: @employee.subordinates.first.id)
  end

  test "admin can see kpis" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can attempt a kpi" do
    visit page_url
    page.accept_confirm do
      click_on "Record Self Assessment"
    end
    sleep(5)
    assert_selector "h3", text: @survey.name
    assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
    take_screenshot
  end

  test "can view kpi summary" do
    visit page_url
    take_screenshot
    @question = @survey.questions.first
    if @question
      find(id: dom_id(@question)).click_on("View summary")
      assert_selector "p", text: "No answer to this question yet."
    end
    take_screenshot
  end

  test "lead can see his KPIss" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "lead can see his subordiates KPIs" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit subordinate_page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "lead can not see someone elseses KPIs" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @lead.decorate.display_name
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "member can see his KPIs" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "member can not see someone elses KPIs" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @member.decorate.display_name
    assert_selector "div#employee-tabs", text: "KPIs"
  end
end
