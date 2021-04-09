require "application_system_test_case"

class TeamTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_participants_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Project Participants"
    assert_text "Add New Participant"
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can redirect to employee detail page on participant click" do
    visit page_url
    participant = @project.participants.first
    click_on "#{participant.first_name} #{participant.last_name}"
    assert_selector "h1", text: "#{participant.first_name} #{participant.last_name}"
  end

  test "can add new participant" do
  end

  test "can not add participant with empty params" do
  end

  test "can delete a participant" do
  end

  test "can edit a participant" do
  end

  test "can not edit participant with invalid params" do
  end
end
