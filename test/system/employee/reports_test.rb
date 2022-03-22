require "application_system_test_case"
require "nokogiri"

class EmployeeReportsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_reports_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_selector "div#employee-tabs", text: "Reports"
    assert_text "Reports"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new report" do
    visit page_url
    click_on "Submit New Report"
    fill_in "Title", with: "Some Random report Title"
    fill_in_rich_text_area "new_report", with: "This is some report"
    page.accept_confirm do
      click_on "Submit Report"
    end
    take_screenshot
    assert_selector "tr", text: "Some Random report Title"
  end

  test "can add new template report if assigned" do
    visit page_url
    @assign = @employee.templates_assignees.first
    find("li", id: dom_id(@assign)).click_link(@assign.template.title)
    page.accept_confirm do
      click_on "Submit Report"
    end
    take_screenshot
    assert_selector "tr", text: @assign.template.title
  end

  test "can draft new report" do
    visit page_url
    click_on "Submit New Report"
    fill_in "Title", with: "Some Random report Title"
    fill_in_rich_text_area "new_report", with: "This is some report"
    click_on "Save As Draft"
    take_screenshot
    assert_selector "tr", text: "Some Random report Title"
  end

  test "can not draft report with empty details" do
    visit page_url
    click_on "Submit New Report"
    click_on "Save As Draft"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    take_screenshot
  end

  test "can not add report with empty details" do
    visit page_url
    click_on "Submit New Report"
    page.accept_confirm do
      click_on "Submit Report"
    end
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can see report detail page" do
    visit page_url
    report = @employee.reports.first
    find("tr", id: dom_id(report)).click_link(report.title)
    assert_selector "h3", text: report.title
    take_screenshot
  end

  test "can delete a report" do
    visit page_url
    report = @employee.reports.first
    page.accept_confirm do
      find("tr", id: dom_id(report)).click_link("Delete")
    end
    assert_no_text report.title
    take_screenshot
  end

  test "can not show add report when user is deactivated" do
    inactive_employee = users(:inactive)
    visit employee_reports_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New Report"
  end

  test "can edit report if not submitted" do
    visit page_url
    report = @employee.reports.where(submitted: false).first
    find("tr", id: dom_id(report)).click_link("Edit")
    title = "Some Random Report Title Edited"
    fill_in "Title", with: ""
    fill_in "Title", with: title
    fill_in_rich_text_area dom_id(report), with: title
    take_screenshot
    page.accept_confirm do
      click_on "Submit Report"
    end
    assert_selector "p.notice", text: "Report was successfully updated."
    assert_selector "tr", text: title
    take_screenshot
  end
  test "can not edit report if submitted" do
    sign_out(@employee)
    @employee = users(:member)
    sign_in @employee
    visit page_url
    report = @employee.reports.where(submitted: true).first
    within "tr##{dom_id(report)}" do
      assert_no_text "Edit"
      assert_no_text "Delete"
    end
    take_screenshot
  end

  test "can not edit report with invalid params" do
    visit page_url
    report = @employee.reports.where(submitted: false).first
    find("tr", id: dom_id(report)).click_link("Edit")

    fill_in "Title", with: nil
    page.accept_confirm do
      click_on "Submit Report"
    end
    assert_selector "p.alert", text: "Failed to update. Please try again."
    take_screenshot
  end

  test "can comment on report" do
    visit page_url
    report = @employee.reports.first
    find("tr", id: dom_id(report)).click_link(report.title)
    fill_in "comment", with: "This is a comment"
    assert_emails 1 do
      click_on "Comment"
      sleep(0.5)
    end
    assert_selector "ul#comments", text: "This is a comment"
    assert_text "Edit"
    assert_text "Delete"
    take_screenshot
  end
end
