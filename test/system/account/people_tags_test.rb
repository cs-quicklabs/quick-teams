require "application_system_test_case"

class PeopleTagsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_people_tags_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "People Tags"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new people tag" do
    visit page_url
    fill_in "Add New Tag", with: "New Tag"
    choose(option: "blue")
    click_on "Save"
    take_screenshot
    assert_text "Tag was created successfully."
    assert_selector "#people_tag_name", text: ""
  end

  test "can not add an empty people tag" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate people tag" do
    visit page_url
    fill_in "Add New Tag", with: people_tags(:star).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_people_tag_url(people_tags(:star), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a tag" do
    visit page_url
    people_tag = people_tags(:star)

    assert_selector "li", text: people_tag.name
    page.accept_confirm do
      find("li", text: people_tag.name).click_on("Delete")
    end
    assert_no_selector "li", text: people_tag.name
  end

  test "can edit people tag" do
    visit page_url
    people_tag = people_tags(:star)

    assert_selector "li", text: people_tag.name
    find("li", text: people_tag.name).click_on("Edit")
    within "turbo-frame#people_tag_#{people_tag.id}" do
      fill_in "people_tag_name", with: "Edited Name"
      choose(option: "blue")
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can not edit people tag with exiting name" do
    visit page_url
    people_tag = people_tags(:star)
    gold = people_tags(:gold)

    assert_selector "li", text: people_tag.name
    find("li", text: people_tag.name).click_on("Edit")
    within "turbo-frame#people_tag_#{people_tag.id}" do
      fill_in "people_tag_name", with: gold.name
      choose(option: "blue")
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with People Tags selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "People Tags"
    end
  end
end
