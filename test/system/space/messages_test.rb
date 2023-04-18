require "application_system_test_case"

class ThreadsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @space = @user.spaces.where(archive: false, user_id: @user.id).first
    @message = @space.messages.where(published: "true").first
    sign_in @user
  end

  def page_url
    space_messages_url(script_name: "/#{@account.id}", space_id: @space.id)
  end

  def messages_page_url
    space_message_url(script_name: "/#{@account.id}", space_id: @space.id, id: @message.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_text "Add New Thread"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show message detail page" do
    visit page_url
    within "div#threads" do
      find("li", id: dom_id(@message)).click_link
    end
    within "div#message-header" do
      assert_selector "h3", text: @message.title
      assert_selector "div", text: @message.body
    end
    take_screenshot
  end

  test "can create a new message" do
    visit page_url
    click_on "Add New Thread"
    fill_in "message_title", with: "Thread"
    fill_in_rich_text_area "new_message", with: "This is some message"
    page.accept_confirm do
      click_on "Publish"
    end
    take_screenshot
    assert_selector "p.notice", text: "Thread was created successfully."
  end

  test "can not create with empty title body" do
    visit page_url
    click_on "Add New Thread"
    assert_selector "h1", text: "Add New Thread"
    page.accept_confirm do
      click_on "Publish"
    end
    take_screenshot
    assert_selector "h1", text: "Add New Thread"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
  end

  test "can edit a message" do
    visit messages_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Thread"
    fill_in "message_title", with: "Thread"
    fill_in_rich_text_area dom_id(@message), with: "This is some message"
    page.accept_confirm do
      click_on "Update"
    end
    assert_selector "p.notice", text: "Thread was updated successfully."
  end

  test "can not edit a message with invalid name" do
    visit messages_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Thread"
    fill_in "message_title", with: ""
    page.accept_confirm do
      click_on "Update"
    end
    take_screenshot
  end

  test "can delete message" do
    visit messages_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Thread was removed successfully."
  end

  test "can comment on a message" do
    visit messages_page_url
    scroll_to(page.find("div", id: "comment-form"))
    click_on "Add a comment"
    within "#add" do
      fill_in_rich_text_area "message_comment_body", with: "This is a comments"
      click_on "Comment"
    end
    assert_text "This is a comment"
  end

  test "can not comment on a message with empty body" do
    visit messages_page_url
    click_on "Add a comment"
    within "#add" do
      click_on "Comment"
      assert_selector "div#error_explanation", text: "Body can't be blank"
    end
  end

  test "can edit comment on message" do
    visit messages_page_url
    @comment = @message.message_comments.where(user_id: @user.id).first
    within "turbo-frame##{dom_id(@comment)}" do
      find("button", id: "comment-menu").click
      take_screenshot
      click_on "Edit"
      sleep 1
      fill_in_rich_text_area "message_comment_body", with: "This is an edited comment"
      click_on "Comment"
    end
    assert_text "This is an edited comment"
    take_screenshot
  end

  test "can not edit comment on message with empty body" do
    visit messages_page_url
    @comment = @message.message_comments.where(user_id: @user.id).first
    within "turbo-frame##{dom_id(@comment)}" do
      find("button", id: "comment-menu").click
      click_on "Edit"
      fill_in_rich_text_area "message_comment_body", with: ""
      click_on "Comment"
    end
    assert_selector "div#error_explanation", text: "Body can't be blank"
  end
end
