require "application_system_test_case"

class ProjectTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    projects_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Projects"
    assert_text "New Project"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show project detail page" do
    visit page_url
    click_on "Gotasker in Engineering"
    assert_text "Add New Participant"
  end

  test "can create a new project" do
  end

  test "can edit a project" do
  end

  test "can archive a project" do
  end

  test "can unarchive a project" do
  end

  test "can see project archives and restore project" do
  end
end
