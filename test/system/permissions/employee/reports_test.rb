require "application_system_test_case"

class EmployeeReportsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    @report = @employee.reports.where(submitted: false).first
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_reports_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def page_detail_url
    employee_report_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @report.id)
  end

  test "admin can see employee reports" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "div#new_report"
    assert_selector "tbody#reports"

    #can see delete button for employee reports
    @employee.reports.each do |report|
      assert_selector "tr##{dom_id(report)}", text: "Delete"
    end
  end

  test "admin can assign template to employee" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    @template = templates(:one)
    visit page_url
    select @employee.decorate.display_name_position, from: "assignable[assignable_id]"
    click_on "Assign"
    assert_text @employee.decorate.display_name
    #can see delete button for employee reports
    @template.templates_assignees.includes(:user).each do |assign|
      assert_selector "li##{dom_id(assign)}", text: assign.decorate.display_name
      assert_selector "li##{dom_id(assign)}", text: "Delete"
    end
  end

  test "admin can see his own reports" do
    sign_out @employee
    sign_in users(:super)
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "div#new_report"
    assert_selector "tbody#reports"

    #can see delete button for his reports
    @employee.reports.each do |report|
      assert_selector "tr##{dom_id(report)}", text: "Delete"
    end
  end
  test "admin can see own report detail " do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @report.title
    #can comment on report
    assert_selector "textarea#comment"
  end

  test "admin can see employee report details" do
    sign_out @employee
    @admin = users(:super)
    sign_in @admin
    @employee = users(:member)
    @report = @employee.reports.where(submitted: false).first
    visit page_detail_url
    assert_selector "h3", text: @report.title
    #can comment on report
    assert_selector "textarea#comment"
  end

  test "lead can see subordinate reports" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "div#new_report"
    assert_selector "tbody#reports"
  end

  test "lead can not see someone elses reports" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:super)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
    assert_no_selector "div#new_report"
    assert_no_selector "tbody#reports"
  end

  test "lead can see his own reports" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "div#employee-tabs", text: "Reports"
    assert_selector "div#new_report"
    assert_selector "tbody#reports"
  end

  test "lead can see own report details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    @report = @employee.reports.where(submitted: false).first
    visit page_detail_url
    assert_selector "h3", text: @report.title
    #can not comment on report
    assert_selector "textarea#comment"
  end

  test "lead can see subordinate report details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    @report = @employee.reports.where(submitted: false).first
    visit page_detail_url
    assert_selector "h3", text: @report.title
    #can comment on report
    assert_selector "textarea#comment"
  end

  test "lead can not see someone elses report detail" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "member can see his own reports" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Reports"
    # can not create a report
    assert_selector "div#new_report"
    # can see report detail button
    # can not see edit delete button
    @employee.reports.each do |report|
      assert_no_selector "li##{dom_id(report)}", text: "Edit"
      assert_no_selector "li##{dom_id(report)}", text: "Delete"
    end
  end

  test "member can see his own report details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    @report = @employee.reports.where(submitted: false).first
    visit page_detail_url
    assert_selector "h3", text: @report.title
    #can comment on report
    assert_selector "textarea#comment"
  end

  test "member can not see someone elses reports" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "member can not see someone elses report details" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @member.decorate.display_name
  end
end
