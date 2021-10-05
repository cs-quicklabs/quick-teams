require "application_system_test_case"

class AssigneesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @survey = Survey::Survey.where(survey_type: "kpi").where(survey_for: "user").first
    sign_in @user
  end

  def page_url
    survey_assignees_url(script_name: "/#{@account.id}", survey_id: @survey.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: @survey.name
    assert_selector "div#survey-tabs", text: "Assignees"
    assert_selector "div#employee-assignees"
    assert_selector "section#add-assignee"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a assignee" do
    visit page_url
    find(:select, id: "assign_id").find(:xpath, "option[3]").select_option
    click_on "Add Assignee"
    assert_selector "p", text: "Assignee was added successfully."
  end

  test "can delete a question" do
    visit page_url
    find(:select, id: "assign_id").find(:xpath, "option[3]").select_option
    click_on "Add Assignee"
    take_screenshot
    @assignee = User.where(kpi_id: @survey).first
    page.accept_confirm do
      find("tr", id: dom_id(@assignee)).click_link("Delete")
    end
    take_screenshot
    assert_selector "p", text: "Assignee was deleted"
  end
end
