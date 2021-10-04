require "application_system_test_case"

class ProjectStatusesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_project_statuses_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Project Status"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new project status" do
    visit page_url
    fill_in "Add New Status", with: "New Status"
    choose(option: "yellow")
    click_on "Save"
    take_screenshot
    assert_text "Project Status was created successfully."
    assert_selector "#project_status_name", text: ""
  end

  test "can not add an empty project status" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate project status" do
    visit page_url
    fill_in "Add New Status", with: project_statuses(:tentative).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_project_status_url(project_statuses(:tentative), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a project status" do
    visit page_url
    project_status = project_statuses(:unused)

    assert_selector "li", text: project_status.name
    page.accept_confirm do
      find("li", text: project_status.name).click_on("Delete")
    end
    assert_no_selector "li", text: project_status.name
  end

  test "can edit project status" do
    visit page_url
    project_status = project_statuses(:tentative)

    assert_selector "li", text: project_status.name
    find("li", text: project_status.name).click_on("Edit")
    within "turbo-frame#project_status_#{project_status.id}" do
      fill_in "project_status_name", with: "Edited Name"
      choose(option: "yellow")
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
    take_screenshot
  end

  test "can not edit project status with exiting name" do
    visit page_url
    project_status = project_statuses(:tentative)
    progess = project_statuses(:progess)

    assert_selector "li", text: project_status.name
    find("li", text: project_status.name).click_on("Edit")
    within "turbo-frame#project_status_#{project_status.id}" do
      fill_in "project_status_name", with: progess.name
      choose(option: "yellow")
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Project Status selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Project Status"
    end
  end

  test "can not delete a project status which is being used" do
    visit page_url
    project_status = project_statuses(:tentative)

    assert_selector "li", text: project_status.name
    page.accept_confirm do
      find("li", text: project_status.name).click_on("Delete")
    end
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: project_status.name
  end
end
