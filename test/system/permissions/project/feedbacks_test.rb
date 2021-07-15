require "application_system_test_case"

class ProjectFeedbacksTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_feedbacks_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def page_detail_url
    project_feedback_url(script_name: "/#{@account.id}", project_id: @project.id, id: @project.feedbacks.first.id)
  end

  test "admin can see project feedbacks with edit buttons" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Feedbacks"
    assert_selector "form#new_feedback"
    feedback = @project.feedbacks.first
    assert_selector "div##{dom_id(feedback)}", text: "Show"
    assert_selector "div##{dom_id(feedback)}", text: "Delete"
    feedback = @project.feedbacks.last
    assert_selector "div##{dom_id(feedback)}", text: "Show"
    assert_selector "div##{dom_id(feedback)}", text: "Delete"
  end

  test "lead can not see project feedbacks" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Feedbacks"
    assert_no_selector "form#new_feedback"
  end

  test "lead can not see project feedback details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#feedback-detail"
  end

  test "member can not see project feedbacks" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Feedbacks"
    assert_no_selector "form#new_feedback"
  end

  test "member can not see project feedback details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#feedback-detail"
  end

  test "manager can see project feedbacks without edit buttons" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Feedbacks"
    assert_no_selector "form#new_feedback"
    feedback = @project.feedbacks.first
    assert_selector "div##{dom_id(feedback)}", text: "Show"
    assert_no_selector "div##{dom_id(feedback)}", text: "Delete"
    feedback = @project.feedbacks.last
    assert_selector "div##{dom_id(feedback)}", text: "Show"
    assert_selector "div##{dom_id(feedback)}", text: "Delete" #can delete feedback added by him
  end

  test "manage can see project feedback detail page" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#feedback-detail"
  end

  test "manager can not see feedback from other projects" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Feedbacks"
  end

  test "manager can not see feedback details of other project feedbacks" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    @feedback = @project.feedbacks.first
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Feedbacks"
  end
end
