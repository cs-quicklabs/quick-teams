require "application_system_test_case"

class SpacesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @all_spaces = @user.spaces
    @space = @user.spaces.where(archive: false).first
    @thread = @space.messages.where(published: "true", user_id: @user.id).first
    sign_in @user
  end

  def page_url
    spaces_url(script_name: "/#{@account.id}")
  end

  def space_page_url
    space_messages_url(script_name: "/#{@account.id}", space_id: @space.id)
  end

  def thread_page_url
    space_message_url(script_name: "/#{@account.id}", space_id: @space.id, id: @thread.id)
  end

  test "admin can see spaces which he is part of" do
    visit page_url
    assert_selector "a.nav-selected", text: "Spaces"
    @all_spaces = @user.spaces
    visit space_page_url
    assert_selector "h1", text: @space.title
    take_screenshot
  end

  test "admin can not see spaces which he is not part of" do
    @space = (Space.all - @user.spaces).first
    visit space_page_url
    assert_no_selector "h1", text: @space.title
    take_screenshot
  end

  test "lead can see spaces which he is part of" do
    sign_out @user
    @user = users(:lead)
    sign_in @user
    visit page_url
    assert_selector "nav#menubar", text: "Spaces"
    @space = @user.spaces.first
    visit space_page_url
    assert_text @space.title
    take_screenshot
  end

  test "lead can not see spaces which he is not part of" do
    sign_out @user
    @user = users(:lead)
    sign_in @user
    @space = (Space.all - @user.spaces).first
    visit space_page_url
    assert_no_text @space.title
    take_screenshot
  end

  test "member can see spaces which he is part of" do
    sign_out @user
    @user = users(:member)
    sign_in @user
    visit page_url
    assert_selector "nav#menubar", text: "Spaces"
    @space = @user.spaces.first
    visit space_page_url
    assert_text @space.title
    take_screenshot
  end

  test "member can not see spaces which he is not part of" do
    sign_out @user
    @user = users(:member)
    sign_in @user
    @space = (Space.all - @user.spaces).first
    visit space_page_url
    assert_no_text @space.title
    take_screenshot
  end

  test "admin can add new space" do
    visit page_url
    assert_text "Add New Space"
    click_on "Add New Space"
    assert_selector "h1", text: "Add New Space"
    take_screenshot
  end

  test "lead can add new space" do
    sign_out @user
    @user = users(:lead)
    sign_in @user
    visit page_url
    assert_text "Add New Space"
    click_on "Add New Space"
    assert_selector "h1", text: "Add New Space"
    take_screenshot
  end

  test "member can add new space" do
    sign_out @user
    @user = users(:member)
    sign_in @user
    visit page_url
    assert_text "Add New Space"
    click_on "Add New Space"
    assert_selector "h1", text: "Add New Space"
    take_screenshot
  end

  test "space participant can only pin or unpin a space" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      assert_text "Pin" || "Unpin"
    end
    take_screenshot
  end

  test "space creator can edit delete and archive the space" do
    @space = @all_spaces.select { |space| space.user_id == @user.id && space.archive == false }.first
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      assert_text "Edit"
      assert_text "Archive"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "space participant can not edit archive or delete the space" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    visit space_page_url
    within "#space-header" do
      find("button", id: "space-menu").click
      assert_no_text "Edit"
      assert_no_text "Archive"
      assert_no_text "Delete"
    end
    take_screenshot
  end

  test "space participant can see threads lists" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    visit space_page_url
    @thread = @space.messages.where(published: "true").first
    assert_text @thread.title
    take_screenshot
  end

  test "space participant can see threads details" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    visit space_page_url
    @thread = @space.messages.where(published: "true").first
    click_on @thread.title
    assert_selector "h3", text: @thread.title
    take_screenshot
  end

  test "user which is not space participant can not see thread detail" do
    @space = (Space.all - @all_spaces).first
    @thread = @space.messages.where(published: "true").first
    visit thread_page_url
    assert_no_selector "h3", text: @thread.title
    take_screenshot
  end

  test "space participant can add a new thread" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    visit space_page_url
    assert_text "Add New Thread"
    click_on "Add New Thread"
    assert_selector "h1", text: "Add New Thread"
    take_screenshot
  end

  test "thread draft can be edited by thread creator" do
    @draft = @space.messages.where(published: false, user_id: @user.id).first
    visit space_page_url
    assert_text @draft.title
    find("li", id: dom_id(@draft)).click_on(@draft.title)
    assert_selector "h1", text: "Edit Thread"
    take_screenshot
  end

  test "thread draft can not be edited by other than thread creator" do
    sign_out @user
    @user = users(:member)
    @user = @space.users.where.not(id: @user.id).first
    @draft = @space.messages.where(published: false).first
    sign_in @user
    assert_no_selector "li", id: dom_id(@draft)
    visit edit_space_message_url(@space, @draft)
    assert_no_selector "h1", text: "Edit Thread"
    take_screenshot
  end

  test "space participant can edit a thread" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    @thread = @space.messages.where(published: true).first
    visit thread_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      assert_text "Edit"
    end
    take_screenshot
  end

  test "space participant can not delete a thread" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    @thread = @space.messages.where(published: true).first
    visit thread_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      assert_no_text "Delete"
    end
    take_screenshot
  end

  test "thread creator can edit delete a thread" do
    @thread = @space.messages.where(published: true, user_id: @user.id).first
    visit thread_page_url
    within "#message-header" do
      find("button", id: "message-menu").click
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "space participant can add a new comment" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    @thread = @space.messages.where(published: true).first
    visit thread_page_url
    assert_selector "div#comment-form", text: "Add a comment"
    take_screenshot
  end

  test "only comment creator can edit and delete a comment" do
    @space = @all_spaces.select { |space| space.user_id != @user.id && space.archive == false }.first
    @thread = @space.messages.where(published: true).first
    visit thread_page_url
    @comment = @thread.message_comments.where(user_id: @user.id).first
    within "turbo-frame##{dom_id(@comment)}" do
      find("button", id: "comment-menu").click
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "space creater can only delete any of comments on a thread" do
    @space = @all_spaces.select { |space| space.user_id == @user.id && space.archive == false }.first
    @thread = @space.messages.where(published: true).first
    visit thread_page_url
    @comment = @thread.message_comments.select { |comment| comment.user_id != @user.id }.first
    within "turbo-frame##{dom_id(@comment)}" do
      find("button", id: "comment-menu").click
      assert_no_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end
end
