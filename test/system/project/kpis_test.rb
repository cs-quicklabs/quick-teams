require "application_system_test_case"

class ProjectKpisTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_feedbacks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@employee.first_name} #{@employee.last_name}"
    assert_selector "div#employee-tabs", text: "KPIs"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can attempt a kpi" do
    visit page_url
    page.accept_confirm do
      click_on "Record Self Assessment"
    end
    sleep(5)
    assert_selector "h3", text: @survey.name
    assert_selector "p", text: "Participant: #{@employee.decorate.display_name}"
    take_screenshot
  end

  test "can view kpi summary" do
    visit page_url
    take_screenshot
    @question = @survey.questions.first
    if @question
      find(id: dom_id(@question)).click_on("View summary")
      assert_selector "p", text: "No answer to this question yet."
    end
    take_screenshot
  end
end
