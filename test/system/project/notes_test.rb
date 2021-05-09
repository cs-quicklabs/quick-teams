require "application_system_test_case"

class NotesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_notes_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Notes"
    assert_text "Add New Note"
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new note" do
    visit page_url
    fill_in "note_body", with: "Added some note"
    click_on "Add Note"
    within "#project_notes" do
      assert_text "Added some note"
    end
    take_screenshot
  end

  test "can not add an empty note" do
    visit page_url
    click_on "Add Note"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can delete a note" do
    visit page_url
    note = @project.notes.first
    assert_text note.body
    find("li", id: dom_id(note)).click_link("Delete")
    assert_no_text note.body
    take_screenshot
  end

  test "can not show add notes when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Note"
  end
end
