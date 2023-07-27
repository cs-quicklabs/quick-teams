require "application_system_test_case"

class ProjectAboutTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @project = projects(:one)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    project_about_index_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit projects if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@project.name}"
    assert_text "About"
  end

  test "can edit the Project About" do
    visit page_url
    find("turbo-frame##{dom_id(@project)}").click_on "Edit"
    fill_in "project_about", with: "This is test description about project"
    click_on "Save"
    sleep(0.5)
    assert_text "This is test description about project"
    take_screenshot
  end

  test "can not visit project if not logged in" do
    sign_out @employee

    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can delete project observer" do
    visit page_url
    @observer = @project.project_observers.first
    within "#project-observers" do
      page.accept_confirm do
        find("turbo-frame#user_#{@observer.user_id}").click_on "Remove"
      end
    end
    assert_text "Observer removed successfully"
    take_screenshot
  end

  test "can add project observer" do
    visit page_url
    within "#add-observers" do
      fill_in "search", with: "a"
      first("#project-observer").click
      within "#project-observers" do
        assert_selector "li", count: @project.project_observers.count + 1
      end
    end
    take_screenshot
  end
end
