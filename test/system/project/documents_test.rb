require "application_system_test_case"

class ProjectDocumentsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_feedbacks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Feedbacks"
    assert_text "Add New Feedback"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new document" do
    visit page_url
    fill_in "Title", with: "Some Random Feedback Title"
    fill_in_rich_text_area "new_feedback", with: "This is some feedback"
    click_on "Add Feedback"
    take_screenshot
    assert_selector "ul#feedbacks", text: "Some Random Feedback Title"
  end

  test "can not add document with empty details" do
    visit page_url
    click_on "Add Feedback"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can see document detail page" do
    visit page_url
    feedback = @project.feedbacks.first
    find("li", id: dom_id(feedback)).click_link("Show")
    assert_selector "h3", text: feedback.title
    take_screenshot
  end

  test "can delete a document" do
    visit page_url
    feedback = @project.feedbacks.first
    page.accept_confirm do
      find("li", id: dom_id(feedback)).click_link("Delete")
    end
    assert_no_text feedback.title
    take_screenshot
  end

  test "can not show add document when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Feedback"
  end

  test "can edit doucment" do
  end

  test "can not edit document with emplty details" do
  end
end
