require "application_system_test_case"

class TemplatesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @template = templates(:one)
    sign_in @user
  end

  def page_url
    templates_url(script_name: "/#{@account.id}")
  end

  def detail_page_url
    template_url(script_name: "/#{@account.id}", id: @template.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Report Templates"
    assert_text "New Template"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show template detail page" do
    visit page_url
    find(id: dom_id(@template)).click
    assert_text @template.title
    take_screenshot
  end

  test "can create a new template" do
    visit page_url
    click_on "New Template"
    fill_in "template_title", with: "Template Sample"
    fill_in_rich_text_area "new_template", with: "This is a sample template body"
    click_on "Save Template"
    take_screenshot
    assert_selector "p.notice", text: "Template was added successfully."
  end

  test "can not create with empty Name " do
    visit page_url
    click_on "New Template"
    assert_selector "h1", text: "Add New template"
    click_on "Save Template"
    take_screenshot
    assert_selector "h1", text: "Add New Template"
  end
  
  test "admin can assign template to employee" do
    visit detail_page_url
    @user=users(:super).decorate
    select @user.display_name_position, from: "assignable[assignable_id]"
    click_on "Assign"
    assert_text @user.display_name
    #can see delete button for employee reports
    @template.templates_assignees.each do |assign|
      assert_selector "li##{dom_id(assign)}", text: assign.assignable.decorate.display_name
      assert_selector "li##{dom_id(assign)}", text: "Delete"
    end
  end

  test "can edit a template" do
    visit detail_page_url
    within "#template-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Template"
    fill_in "template_title", with: "Report Template Sample"
    fill_in_rich_text_area dom_id(@template), with: "This is template body"
    click_on "Save Template"
    assert_selector "p.notice", text: "Template was updated successfully."
  end

  test "can not edit a template with invalid name" do
    visit detail_page_url
    within "#template-header" do
      click_on "Edit"
     end
    assert_selector "h1", text: "Edit Template"
    fill_in "template_title", with: ""
    click_on "Save Template"
    assert_selector "h1", text: "Edit Template"
    take_screenshot
  end


  test "can delete template" do
  @template = templates(:two)
    visit detail_page_url
    within "#template-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Template was removed successfully."
  end
end
