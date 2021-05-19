require "application_system_test_case"

class ProjectTagsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_project_tags_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Project Tags"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new project tag" do
    visit page_url
    fill_in "Add New Tag", with: "New Tag"
    choose(option: "red")
    click_on "Save"
    take_screenshot
    assert_text "Tag was created successfully."
    assert_selector "#project_tag_name", text: ""
  end

  test "can not add an empty project tag" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate project tag" do
    visit page_url
    fill_in "Add New Tag", with: project_tags(:risk).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_project_tag_url(project_tags(:risk), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/turbo-frame/form/li")
  end

  test "can delete a project tag" do
    visit page_url
    project_tag = project_tags(:risk)

    assert_selector "li", text: project_tag.name
    find("li", text: project_tag.name).click_on("Delete")
    assert_no_selector "li", text: project_tag.name
  end

  test "can edit project tag" do
    visit page_url
    project_tag = project_tags(:risk)

    assert_selector "li", text: project_tag.name
    find("li", text: project_tag.name).click_on("Edit")
    within "turbo-frame#project_tag_#{project_tag.id}" do
      fill_in "project_tag_name", with: "Edited Name"
      choose(option: "red")
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
    take_screenshot
  end

  test "can not edit project tag with exiting name" do
    visit page_url
    project_tag = project_tags(:risk)
    uat = project_tags(:uat)

    assert_selector "li", text: project_tag.name
    find("li", text: project_tag.name).click_on("Edit")
    within "turbo-frame#project_tag_#{project_tag.id}" do
      fill_in "project_tag_name", with: uat.name
      choose(option: "red")
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with Project Tags selected" do
    visit page_url
    within "#menu" do
      assert_selector "a", count: 10
      assert_selector ".selected", text: "Project Tags"
    end
  end
end
