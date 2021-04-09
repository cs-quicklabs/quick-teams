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
    take_screenshot
    assert_selector "p.notice", text: "Note was added successfully."
  end

  test "can not add an empty note" do
    visit page_url
    click_on "Add Note"
    take_screenshot
    assert_text "Body can't be blank"
  end

  test "can delete a note" do
    visit page_url
    assert_text notes(:one).body
    find(:xpath, "/html/body/main/main/div/div/div[1]/section/div/div/ul/li/div/div[2]/div[3]/a").click
    take_screenshot
    assert_selector "p.notice", text: "Note was removed successfully."
    assert_no_text notes(:one).body
  end
end
