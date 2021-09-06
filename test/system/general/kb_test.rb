require "application_system_test_case"

class KbTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    kbs_url(script_name: "/#{@account.id}")
  end

  def new_page_url
    new_kb_url(script_name: "/#{@account.id}")
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Documents"
  end

  test "can not visit index if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "admin can see all documents" do
    visit page_url
    @documents = Kb.all
    @documents.each do |document|
      assert_selector "tr", id: "#{dom_id(document)}"
    end
  end

  test "lead can see documents related to him" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    visit page_url
    @documents = Kb.visible_documents_for_user(@lead)
    @documents.each do |document|
      assert_includes [nil, @lead.discipline], document.discipline
      assert_includes [nil, @lead.job], document.job
    end
  end

  test "member can see documents related to him" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    visit page_url
    @documents = Kb.visible_documents_for_user(@member)
    @documents.each do |document|
      assert_includes [nil, @member.discipline], document.discipline
      assert_includes [nil, @member.job], document.job
    end
  end

  test "admin can add document" do
    visit new_page_url
    fill_in "Document", with: "Test document"
    fill_in "Link", with: "www.google.com"
    fill_in "kb_comments", with: "These are some comments"
    click_on "Save Document"
    assert_selector "p.notice", text: "Document was successfully Added."
  end

  test "can not add document with wrong params" do
    visit new_page_url
    click_on "Save Document"
    assert_selector "p.alert", text: "Failed to add knowledge base. Please try again."
  end

  test "lead can not add document" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    visit new_page_url
    assert_selector "h1", text: @employee.decorate.display_name
  end

  test "member can not add document" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    visit new_page_url
    assert_selector "h1", text: @employee.decorate.display_name
  end
end
