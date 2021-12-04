require "application_system_test_case"

class EmployeeReportsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_reports_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see employee reports" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"

    #can see delete button for employee reports
    @employee.reports.each do |report|
      assert_selector "tr##{dom_id(report)}", text: "Delete"
    end
  end

  test "admin can see his own reports" do
    sign_out @employee
    sign_in users(:super)
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"

    #can see delete button for his reports
    @employee.reports.each do |report|
      assert_selector "tr##{dom_id(report)}", text: "Delete"
    end
  end

  test "lead can see subordinate reports" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"
  end

  test "lead can not see someone elses reports" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:super)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_no_selector "form#new_report"
    assert_no_selector "tbody#reports"
  end

  test "lead can see his own reports" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"
  end

  test "manager can not see someone elses reports" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @manager.decorate.display_name
    assert_no_selector "form#new_report"
    assert_no_selector "tbody#reports"
  end

  test "manager can see his own reports" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"

    #can see delete button for his created reports
    #can not see delete button for his not created reports
    @employee.reports.each do |report|
      if report.user == @employee
        assert_selector "tr##{dom_id(report)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(report)}", text: "Delete"
      end
    end
  end

  test "member can see own reports" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "form#new_report"
    assert_selector "tbody#reports"
  end

  test "member can not see someone elsees report" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
    assert_no_selector "form#new_report"
    assert_no_selector "tbody#reports"
  end
end
