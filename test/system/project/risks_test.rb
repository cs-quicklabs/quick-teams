require "application_system_test_case"

class ProjectNotesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:one)
    sign_in @employee
  end

  def page_url
    project_risks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@project.name}"
    assert_text "Risk"
    assert_text "Add New Risk"
  end
  test "can not show add risks when project is archived" do
    archived_project = projects(:archived)
    visit project_feedbacks_url(script_name: "/#{@account.id}", project_id: archived_project.id)
    assert_no_text "Add New Risk"
  end

  test "can not visit index page if not logged in" do
    sign_out @employee
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new risk" do
    visit page_url
    fill_in "risk_body", with: "Added some risk"
    click_on "Add Risk"
    within "#risks" do
      assert_text "Added some risk"
    end
    take_screenshot
  end

  test "can not add an empty risk" do
    visit page_url
    click_on "Add Risk"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can delete a risk" do
    visit page_url
    risk = @project.risks.first
    assert_text risk.body
    page.accept_confirm do
      find(id: dom_id(risk)).click_link("Delete")
    end
    assert_no_text risk.body
    take_screenshot
  end

  test "can mitigate or reopen a risk" do
    visit page_url
    risk = @project.risks.first
    assert_text risk.body
    find(id: dom_id(risk)).click_on("Mitigate")
    take_screenshot
    sleep(1)
    assert risk.status, false
    find(id: dom_id(risk)).click_on("Reopen")
    take_screenshot
    sleep(1)
    assert risk.status, true
  end
end
