require "application_system_test_case"

class SpacesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @space = @user.spaces.where(archive: false, user_id: @user.id).first
    sign_in @user
  end

  def page_url
    spaces_url(script_name: "/#{@account.id}")
  end

  def space_page_url
    space_messages_url(script_name: "/#{@account.id}", space_id: @space.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Spaces"
    assert_text "Add New Space"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show space detail page" do
    visit page_url
    find("li", id: dom_id(@space)).click
    within "#space-header" do
      assert_text @space.title
      assert_text @space.description
    end
    take_screenshot
  end

  test "can create a new space" do
    visit page_url
    click_on "Add New Space"
    fill_in "space_title", with: "Space title"
    fill_in "space_description", with: "This is some space"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "Space was created successfully."
  end

  test "can not create with empty title Discription" do
    visit page_url
    click_on "Add New Space"
    assert_selector "h1", text: "Add New Space"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Add New Space"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Description can't be blank"
  end

  test "can edit a space" do
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Space"
    fill_in "space_title", with: "Space"
    click_on "Save"
    assert_selector "p.notice", text: "Space was updated successfully."
  end

  test "can not edit a space with invalid title" do
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Space"
    fill_in "space_title", with: ""
    click_on "Save"
    take_screenshot
  end

  test "can delete space" do
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Space was removed successfully."
  end

  test "can pin a space" do
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      click_on "Pin"
    end
    take_screenshot
    assert_selector "p.notice", text: "Space was pinned successfully."
  end

  test "can archive a space" do
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      page.accept_confirm do
        click_on "Archive"
      end
    end
  end

  test "can unarchive a space" do
    @space = spaces(:archived)
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      page.accept_confirm do
        click_on "Unarchive"
      end
    end
  end

  test "can unpin a space" do
    @space = spaces(:pinned)
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      click_on "Unpin"
    end
    take_screenshot
    assert_selector "p.notice", text: "Space was unpinned successfully."
  end
end
