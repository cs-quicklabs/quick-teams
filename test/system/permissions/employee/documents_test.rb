require "application_system_test_case"

class EmployeeDocumentsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @actor = users(:actor)
    @account = @actor.account
    ActsAsTenant.current_tenant = @account
    @employee = users(:regular)
    sign_in @actor
  end

  def page_url
    employee_documents_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see own documents" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"
    @employee.documents.each do |document|
      assert_selector "tr##{dom_id(document)}", text: "Edit"
      assert_selector "tr##{dom_id(document)}", text: "Delete"
    end
  end

  test "admin can see and add someone elses documents" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"
    @employee.documents.each do |document|
      assert_selector "tr##{dom_id(document)}", text: "Edit"
      assert_selector "tr##{dom_id(document)}", text: "Delete"
    end
  end

  test "lead can see and add own documents" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"

    @employee.documents.each do |document|
      if document.user_id == @employee.id
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "lead can see and add subordinate documents" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    # can create a document for subordinate
    assert_selector "form#new_document"
    # can edit, delete documents create by him
    @employee.documents.each do |document|
      if document.user == @lead
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "lead can not see someone elses documents" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "member can see and add his own documents" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"
    @employee.documents.each do |document|
      if document.user == @employee
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "member can not see someone elses documents" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "project manager can see and add his own documents" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    assert_selector "form#new_document"
    @employee.documents.each do |document|
      if document.user == @employee
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "project manager can see and add project participant documents" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Documents"
    # can create a document for subordinate
    assert_selector "form#new_document"
    # can edit, delete documents create by him
    @employee.documents.each do |document|
      if document.user == @lead
        assert_selector "tr##{dom_id(document)}", text: "Edit"
        assert_selector "tr##{dom_id(document)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(document)}", text: "Edit"
        assert_no_selector "tr##{dom_id(document)}", text: "Delete"
      end
    end
  end

  test "project manager can not see someone elses documents" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @manager.decorate.display_name
  end
end
