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

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_text "Employee reports"
    assert_text "Add New report"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new report" do
    visit page_url
    fill_in "Title", with: "Some Random report Title"
    fill_in_rich_text_area "new_report", with: "This is some report"
    click_on "Add Report"
    take_screenshot
    assert_selector "ul#reports", text: "Some Random report Title"
  end
test "can draft new report" do
    visit page_url
    fill_in "Title", with: "Some Random report Title"
    fill_in_rich_text_area "new_report", with: "This is some report"
    click_on "Draft Report"
    take_screenshot
    assert_selector "ul#reports", text: "Some Random report Title"
  end
    test "can not draft report with empty details" do
    visit page_url
    click_on "Draft Report"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can not add report with empty details" do
    visit page_url
    click_on "Add report"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can see report detail page" do
    visit page_url
    report = @employee.reports.first
    find("li", id: dom_id(report)).click_link("Show")
    assert_selector "h3", text: report.title
    take_screenshot
  end

  test "can delete a report" do
    visit page_url
    report = @employee.reports.first
    page.accept_confirm do
      find("li", id: dom_id(report)).click_link("Delete")
    end
    assert_no_text report.title
    take_screenshot
  end

  test "can not show add report when user is deactivated" do
    inactive_employee = users(:inactive)
    visit employee_reports_url(script_name: "/#{@account.id}", employee_id: inactive_employee.id)
    assert_no_text "Add New report"
  end

  test "can edit report if not submitted" do
    visit page_url
    report = @employee.reports.where(submitted:false).first
    find("li", id: dom_id(report)).click_link("Edit")
    title = "Some Random Goal Title Edited"
    fill_in "Title", with: ""
    fill_in "Title", with: title
    fill_in_rich_text_area dom_id(report), with: title
    take_screenshot
    click_on "Edit report"
    assert_selector "p.notice", text: "report was successfully updated."
    assert_selector "h3", text: title
    assert_selector "div.trix-content", text: title
    take_screenshot
  end
  test "can not edit report if submitted" do
    visit page_url
    report = @employee.reports.where(submitted:true).first
    within "#dom_id(report)" do
      assert_no_text edit
    end
    take_screenshot
  end

  test "can not edit report with invalid params" do
    visit page_url
    report = @employee.reports.first
    find("li", id: dom_id(report)).click_link("Edit")
    fill_in "Title", with: nil
    click_on "Edit report"
    assert_selector "p.alert", text: "Failed to update. Please try again."
    take_screenshot
  end
end
