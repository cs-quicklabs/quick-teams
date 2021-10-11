require "application_system_test_case"

class ProjectRisksTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_risks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  test "admin can see project risks with edit buttons" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Risks"
    assert_selector "form#new_risk"
    risk = @project.risks.first
    assert_selector "tr##{dom_id(risk)}", text: "Mitigate"
    assert_selector "tr##{dom_id(risk)}", text: "Delete"
    risk = @project.risks.last
    assert_selector "tr##{dom_id(risk)}", text: "Mitigate"
    assert_selector "tr##{dom_id(risk)}", text: "Delete"
  end

  test "lead can not see project risks" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Risks"
  end

  test "member can not see project risks" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Risks"
  end

  test "manager can see project risk with edit buttons" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Risks"
    assert_selector "form#new_risk"
    risk = @project.risks.first
    assert_selector "tr##{dom_id(risk)}", text: "Mitigate"
    assert_selector "tr##{dom_id(risk)}", text: "Delete"
  end

  test "manger can not see risks other than his project risks" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    @project = projects(:one)
    visit page_url
    assert_no_selector "div#project-tabs", text: "Risks"
    assert_no_selector "form#new_risk"
  end
end
