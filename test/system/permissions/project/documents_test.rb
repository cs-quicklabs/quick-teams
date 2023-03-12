require "application_system_test_case"

class ProjectDocumentssTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_documents_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project documents with edit buttons" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Documents"
    assert_selector "form#new_document"
    @project.documents.each do |document|
      assert_selector "tr##{dom_id(document)}", text: "Edit"
      assert_selector "tr##{dom_id(document)}", text: "Delete"
    end
  end

  test "lead can not see project documents" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Documents"
    assert_no_selector "form#new_document"
  end

  test "member can not see project documents" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Documents"
    assert_no_selector "form#new_document"
  end

  test "manager can see project documents without edit buttons" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Documents"
    assert_selector "form#new_document"
    documents = @project.documents

    documents.each do |document|
      if document.user_id == @employee.id
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "manager can not see documents from other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Documents"
  end

  test "observer can see project documents without edit buttons" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Documents"
    assert_selector "form#new_document"
    documents = @project.documents

    documents.each do |document|
      if document.user_id == @employee.id
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "observer can not see documents from other projects" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:managed)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Documents"
  end
end
