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

  test "project manager can see his KPIs" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "project manager can see his project participants KPIs" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit subordinate_page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "project manager can not see someone elseses KPIs" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @manager.decorate.display_name
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "project observer can see his KPIs" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    visit page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "project observer can see his project participants KPIs" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:actor)
    visit subordinate_page_url
    take_screenshot
    assert_equal @survey.account.name, "Crownstack technologies"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "project observer can not see someone elseses KPIs" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:admin)
    visit page_url
    take_screenshot
    assert_selector "h1", text: @observer.decorate.display_name
    assert_selector "div#employee-tabs", text: "KPIs"
  end
end
