require "application_system_test_case"

class ProjectDocumentsTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    @project = projects(:one)
    @document = @project.documents.first
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_documents_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def edit_page_url
    edit_project_document_url(script_name: "/#{@account.id}", project_id: @project.id, id: @document.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: @project.name
    assert_selector "div#project-tabs", text: "Documents"
    assert_selector "form#new_document"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new document" do
    visit page_url
    fill_in "document_filename", with: "Some Random document Title"
    fill_in "document_link", with: "www.google.com"
    fill_in "document_comments", with: "This is comment"
    click_on "Add Document"
    take_screenshot
    assert_selector "tbody#documents", text: "Some Random document Title"
  end

  test "can not add document with empty details" do
    visit page_url
    click_on "Add Document"
    assert_selector "div#error_explanation", text: "Filename can't be blank"
    assert_selector "div#error_explanation", text: "Link can't be blank"

    take_screenshot
  end

  test "can delete a document" do
    visit page_url
    page.accept_confirm do
      find("tr", id: dom_id(@document)).click_link("Delete")
    end
    assert_no_selector "tr##{dom_id(@document)}"
    take_screenshot
  end

  test "can not show add document when project is archived" do
    inactive_project = projects(:archived)
    visit project_documents_url(script_name: "/#{@account.id}", project_id: inactive_project.id)
    assert_no_selector "form#new_document"
  end

  test "can edit document" do
    visit edit_page_url
    title = "Some Document Edited"
    fill_in "document_filename", with: ""
    fill_in "document_filename", with: title
    take_screenshot
    click_on "Edit Document"
    assert_selector "p.notice", text: "document was successfully updated."
    assert_selector "tr##{dom_id(@document)}", text: "Some Document Edited"
    take_screenshot
  end

  test "can not edit document with invalid params" do
    visit edit_page_url
    fill_in "document_filename", with: nil
    click_on "Edit Document"
    assert_selector "p.alert", text: "Failed to update. Please try again."
    take_screenshot
  end
end
