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

  test "admin can only view spaces that belong to him and  comment on spaces shared with him" do
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
    click_on @thread.title
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
