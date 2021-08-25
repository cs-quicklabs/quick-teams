require "application_system_test_case"
require "nokogiri"

class KbTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @actor = users(:actor)
    @account = @actor.account
    ActsAsTenant.current_tenant = @account
    @employee = users(:regular)
    sign_in @actor
  end

  def page_url
    kb_index_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "kbs"
    assert_text "New kb"
  end

  test "admin can see own kbs" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "form#new_kb"
    @kbs.each do |kb|
      assert_selector "tr##{dom_id(kb)}", text: "Edit"
      assert_selector "tr##{dom_id(kb)}", text: "Delete"
    end
  end

  test "lead can see and add own kbs" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "form#new_kb"

    @kbs.each do |kb|
      if kb.user_id == @employee.id
        assert_selector "tr##{dom_id(kb)}", text: "Edit"
        assert_selector "tr##{dom_id(kb)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(kb)}", text: "Edit"
        assert_no_selector "tr##{dom_id(kb)}", text: "Delete"
      end
    end
  end

  test "lead can not see someone elses kbs" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
  end

  test "member can see his kbs" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
  end

  test "member can not see someone elses kbs" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
  end
end
