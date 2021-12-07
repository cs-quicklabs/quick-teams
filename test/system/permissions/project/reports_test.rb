require "application_system_test_case"

class ProjectReportsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    @report = @project.reports.first
    sign_in @employee
  end

  def page_url
    project_reports_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def page_detail_url
    project_report_url(script_name: "/#{@account.id}", project_id: @project.id, id: @report.id)
  end

  test "admin can see project reports" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Reports"
    assert_selector "div#report-list"
    assert_selector "form#new_report"
  end
  test "admin can see project report details" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#report-detail"
    #can see edit
    assert_selector "a", text: "Edit"
    #can comment
    assert_selector "div#comment"
  end

  test "lead can not see project reports" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Reports"
  end

  test "lead can not see project report details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#report-detail"
  end

  test "member can not see project reports" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Reports"
  end

  test "member can not see project report details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#report-detail"
  end

  test "manager can see project reports" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Reports"
    assert_selector "div#report-list"
    assert_selector "form#new_report"
  end

  test "manager can see project report details" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#report-detail"
    # can comment on report
    assert_selector "div#comment"
  end

  test "manager can not see project reports of other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Reports"
  end

  test "manager can not see project report details of different project" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    @report = @project.reports.first
    sign_in @employee
    visit page_url
    assert_no_selector "div#report-detail"
  end
end
