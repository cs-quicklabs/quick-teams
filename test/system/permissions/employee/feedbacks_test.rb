require "application_system_test_case"

class EmployeeFeedbacksTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_feedbacks_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def page_detail_url
    employee_feedback_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @employee.feedbacks.first.id)
  end

  test "admin can see his feedbacks" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    assert_selector "form#new_feedback"
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_selector "tr##{dom_id(feedback)}", text: "Delete"
      end
    end
  end

  test "admin can see someone elses feedback" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    assert_selector "form#new_feedback"
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_selector "tr##{dom_id(feedback)}", text: "Delete"
      end
    end
  end

  test "admin can see feedback details" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_selector "button", text: "Publish"
  end

  test "lead can see his feedbacks" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can not create a feedback for himself
    assert_no_selector "form#new_feedback"
    # can not edit, delete feedback for himself
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(feedback)}"
      end
    end
  end

  test "lead can see his subordinates feedback" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can create a feedback for subordinate
    assert_selector "form#new_feedback"
    # can edit feedbck for subordinates
    # can delete feedback create by him
    @employee.feedbacks.each do |feedback|
      assert_selector "tr##{dom_id(feedback)}", text: "Edit"
      if feedback.user == @lead
        assert_selector "tr##{dom_id(feedback)}", text: "Delete"
      end
    end
  end

  test "lead can not see someone elsese feedback" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "lead can see his feedback details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "lead can see his subordinates feedback details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "lead can not see someone elses feedback details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "member can see his feedbacks" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can not create a goal
    assert_no_selector "form#new_feedback"
    # can see feedback detail button
    # can not see edit buttons
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(feedback)}"
      end
    end
  end

  test "member can see his feedback details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "textarea#comment"
    assert_no_selector "button", text: "Publish"
  end

  test "member can not see someone elses feedback" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "member can not see someone elses feedback details" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "project manager can see his feedbacks" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can not create a feedback for himself
    assert_no_selector "form#new_feedback"
    # can not edit, delete feedback for himself
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(feedback)}"
      end
    end
  end

  test "project manager can see his project participants feedback" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can create a feedback for subordinate
    assert_selector "form#new_feedback"
    # can edit feedbck for subordinates
    # can delete feedback create by him
    @employee.feedbacks.each do |feedback|
      assert_selector "tr##{dom_id(feedback)}", text: "Edit"
      if feedback.user == @manager
        assert_selector "tr##{dom_id(feedback)}", text: "Delete"
      end
    end
  end

  test "project manager can not see someone elsese feedback" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project manager can see his feedback details" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "project manager can see his project participants feedback details" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "project manager can not see someone elses feedback details" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project observer can see his feedbacks" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can not create a feedback for himself
    assert_no_selector "form#new_feedback"
    # can not edit, delete feedback for himself
    @employee.feedbacks.each do |feedback|
      if feedback.published?
        assert_no_selector "tr##{dom_id(feedback)}", text: "Edit"
        assert_no_selector "tr##{dom_id(feedback)}", text: "Delete"
      else
        assert_no_selector "tr##{dom_id(feedback)}"
      end
    end
  end

  test "project observer can see his project participants feedback" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:actor)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Feedbacks"
    # can create a feedback for subordinate
    assert_selector "form#new_feedback"
    # can edit feedbck for subordinates
    # can delete feedback create by him
    @employee.feedbacks.each do |feedback|
      assert_selector "tr##{dom_id(feedback)}", text: "Edit"
      if feedback.user == @manager
        assert_selector "tr##{dom_id(feedback)}", text: "Delete"
      end
    end
  end

  test "project observer can not see someone elsese feedback" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @observer.decorate.display_name
  end

  test "project observer can see his feedback details" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "project observer can see his project participants feedback details" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:actor)
    visit page_detail_url
    assert_selector "h3", text: @employee.feedbacks.first.title
    assert_no_selector "button", text: "Publish"
  end

  test "project observer can not see someone elses feedback details" do
    sign_out @employee
    @observer = users(:abram)
    sign_in @observer
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @observer.decorate.display_name
  end
end
