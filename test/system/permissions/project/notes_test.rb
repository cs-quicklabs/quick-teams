require "application_system_test_case"

class ProjectNotesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_notes_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project notes with edit buttons" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Notes"
    assert_selector "form#new_note"
    note = @project.notes.first
    assert_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_selector "turbo-frame##{dom_id(note)}", text: "Delete"
    note = @project.notes.last
    assert_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_selector "turbo-frame##{dom_id(note)}", text: "Delete"
  end

  test "lead can not see project notes" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Notes"
  end

  test "member can not see project notes" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Notes"
  end

  test "manager can see project note without edit buttons" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Notes"
    assert_selector "form#new_note"

    note = @project.notes.first
    assert_no_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_no_selector "turbo-frame##{dom_id(note)}", text: "Delete"
    note = @project.notes.where(user_id: @employee.id).first
    assert_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_selector "turbo-frame##{dom_id(note)}", text: "Delete"
  end

  test "manger can not see notes other than his project notes" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    @project = projects(:one)
    visit page_url
    assert_no_selector "div#project-tabs", text: "Notes"
    assert_no_selector "form#new_note"
  end

  test "observer can see project note without edit buttons" do
    sign_out @employee
    @employee = users(:abram)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Notes"
    assert_selector "form#new_note"
    note = @project.notes.first
    assert_no_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_no_selector "turbo-frame##{dom_id(note)}", text: "Delete"
    note = @project.notes.where(user_id: @employee.id).first
    assert_selector "turbo-frame##{dom_id(note)}", text: "Edit"
    assert_selector "turbo-frame##{dom_id(note)}", text: "Delete"
  end

  test "observer can not see notes other than his project notes" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    @project = projects(:managed)
    visit page_url
    assert_no_selector "div#project-tabs", text: "Notes"
    assert_no_selector "form#new_note"
  end
end
