require "application_system_test_case"

class SpacesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @space = spaces(:eight)
    sign_in @user
  end

  def page_url
    spaces_url(script_name: "/#{@account.id}")
  end

  def space_page_url
    space_messages_url(script_name: "/#{@account.id}", space_id: @space.id)
  end

  test "admin can see spaces which he is part of" do
  end

  test "admin can not see spaces which he is not part of" do
  end

  test "lead can see spaces which he is part of" do
  end

  test "lead can not see spaces which he is not part of" do
  end

  test "member can see spaces which he is part of" do
  end

  test "member can not see spaces which he is not part of" do
  end

  test "admin can add new space" do
  end

  test "lead can add new space" do
  end

  test "member can add new space" do
  end

  test "space participant can pin a space" do
  end

  test "space creator can edit the space" do
  end

  test "space creator can delete the space" do
  end

  test "space creator can archive the space" do
  end

  test "space participant can not edit the space" do
  end

  test "space participant can not delete the space" do
  end

  test "space participant can not archive the space" do
  end

  test "space participant can see threads lists" do
  end

  test "user which is not space participant can see thread list" do
  end

  test "space participant can see threds details" do
  end

  test "user which is not space participant can see thread detail" do
  end

  test "space participant can add a new thread" do
  end

  test "thread draft can be edited by thread creator" do
  end

  test "thread draft can not be edited by other than thread creator" do
  end

  test "space participant can edit a thread" do
  end

  test "space participant can not delete a thread" do
  end

  test "thread creator can edit delete a thread" do
  end

  test "space participant can add a new comment" do
  end

  test "only comment creator can edit and delete a comment" do
  end

  test "space creater can only delete any of comments on a thread" do
  end
  test "can only view spaces that belong to the employee" do
    visit page_url
    created_spaces = Space.where(archive: false, user_id: @user.id)
    shared_spaces = @user.spaces.where(archive: false)
    archived = Space.where(archive: true, user_id: @user.id)
    within "#created-spaces" do
      assert_text created_spaces.first.title
    end
    within "#shared-spaces" do
      assert_text shared_spaces.first.title
    end
    within "#archived-spaces" do
      assert_text archived.first.title
    end
  end

  test "admin can only view spaces that belong to him and  comment on spaces shared with him if not archived" do
    @space = @user.spaces.where(archive: false).first
    @thread = @space.messages.where(published: true).first

    visit space_page_url
    assert_no_text "Draft"
    within "div#space-header" do
      find("button", id: "space-menu").click
      take_screenshot
      assert_no_text "Edit"
      assert_no_text "Delete"
      assert_no_text "Archive"
      assert_text "Pin" || "Unpin"
    end
    click_on @thread.title
    assert_text @thread.title
    within "div#message-header" do
      find("button", id: "message-menu").click
      take_screenshot
      assert_text "Edit"
      assert_text "Delete"
    end
    within "ul#comments" do
      @comment = @thread.comments.where(user_id: users(:lead).id).first
      within "#comment_#{@comment.id}" do
        assert_no_selector "button", id: "comment-menu"
      end
      user_comment = @thread.comments.where(user_id: @user.id).first
      within "#comment_#{user_comment.id}" do
        find("button", id: "comment-menu").click
        assert_text "Edit"
        assert_text "Delete"
      end
    end
  end

  test "lead can only comment on shared spaces and cannot view draft threads" do
    sign_out @user
    @user = users(:lead)
    sign_in @user
    @space = @user.spaces.where(archive: false).first
    visit space_page_url
    assert_no_text "Add New Thread"
    within "#threads" do
      assert_no_text "Draft"
      @thread = @space.messages.where(published: true).first
      assert_no_selector "a[href='#{edit_space_path(@space)}']"
      assert_no_selector "a[data-method='delete'][href='#{space_path(@space)}']"
      click_on @thread.title
      assert_text @thread.title
      assert_no_selector "a[href='#{edit_space_message_path(@space, @thread)}']"
      assert_no_selector "a[data-method='delete'][href='#{space_message_path(@space, @thread)}']"
    end
  end

  test "lead can not edit other comments" do
    sign_out @user
    @user = users(:lead)
    sign_in @user
    @space = @user.spaces.where(archive: false).first
    @thread = @space.messages.where(published: true).first
    visit space_page_url
    take_screenshot
    click_on @thread.title
    @comment = @thread.comments.where(user_id: users(:regular).id).first
    within "#comment_#{@comment.id}" do
      assert_no_selector "button", id: "comment-menu"
    end
    lead_comment = @thread.comments.where(user_id: @user.id).first
    within "#comment_#{lead_comment.id}" do
      (find "button", id: "comment-menu").click
      assert_text "Edit"
      assert_text "Delete"
    end
  end

  test "user can visit only his spaces" do
    @space = spaces(:nine)
    visit space_page_url
    assert_no_text @space.title
    @thread = @space.messages.where(published: true).first
    visit space_page_url
    assert_no_selector @thread.title
  end
end
