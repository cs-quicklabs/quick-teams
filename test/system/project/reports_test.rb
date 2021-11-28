require "application_system_test_case"

class ProjectReportsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_reports_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project reports"
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

  test "can not add report with empty details" do
    visit page_url
    click_on "Add Report"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
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


  test "can see report detail page" do
    visit page_url
    report = @project.reports.first
    find("li", id: dom_id(report)).click_link("Show")
    assert_selector "h3", text: report.title
    take_screenshot
  end

  test "can delete a report" do
    visit page_url
    report = @project.reports.first
    page.accept_confirm do
      find("li", id: dom_id(report)).click_link("Delete")
    end
    assert_no_text report.title
    take_screenshot
  end

  test "can not show add report when project is archived" do
    archived_project = projects(:archived)
    visit project_reports_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New report"
  end
end
