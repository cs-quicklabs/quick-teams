require "application_system_test_case"
require "nokogiri"

class OnboardingTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test "admin can login" do
    admin = users(:admin)
    visit new_user_session_path
    fill_in "user_email", with: admin.email
    fill_in "user_password", with: "password"
    click_on "Log In"
    assert_current_path(home_path(script_name: "/#{admin.account.id}"))
    take_screenshot
  end

  test "member can login" do
    member = users(:member)
    visit new_user_session_path
    fill_in "user_email", with: member.email
    fill_in "user_password", with: "password"
    click_on "Log In"
    assert_current_path(employee_schedules_path(member, script_name: "/#{member.account.id}"))
    take_screenshot
  end

  test "lead can login" do
    lead = users(:lead)
    visit new_user_session_path
    fill_in "user_email", with: lead.email
    fill_in "user_password", with: "password"
    click_on "Log In"
    assert_current_path(employee_team_path(lead, script_name: "/#{lead.account.id}"))
    take_screenshot
  end

  test "user can send forgotten password email" do
    admin = users(:admin)
    visit new_user_session_path
    click_on "Forgot your password?"
    fill_in "user_email", with: admin.email

    assert_emails 1 do
      click_on "Send me reset password instructions"
      sleep(0.5)
    end
    assert_selector "p.notice", text: "You will receive an email with instructions on how to reset your password in a few minutes."
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.body.to_s)
    link = doc.css("a").first.values.first
    visit link
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Change my password"
    assert_selector "div#error_explanation", text: "Reset password token is invalid" #this is fine because token has been changed.
  end
end
