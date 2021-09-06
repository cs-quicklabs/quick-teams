require "application_system_test_case"

class EmployeeGoalsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @actor = users(:actor)
    @account = @actor.account
    ActsAsTenant.current_tenant = @account
    @employee = users(:regular)
    sign_in @actor
  end

  def page_url
    employee_goals_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def page_detail_url
    employee_goal_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @employee.goals.first.id)
  end

  test "admin can see own goals" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    assert_selector "form#new_goal"
    @employee.goals.each do |goal|
      assert_selector "li##{dom_id(goal)}", text: "Show"
      assert_selector "li##{dom_id(goal)}", text: "Edit"
      assert_selector "li##{dom_id(goal)}", text: "Delete"
    end
  end

  test "admin can see someone elses goals" do
    sign_out @employee
    sign_in users(:super)
    @employee = users(:member)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    assert_selector "form#new_goal"
    @employee.goals.each do |goal|
      assert_selector "li##{dom_id(goal)}", text: "Show"
      assert_selector "li##{dom_id(goal)}", text: "Edit"
      assert_selector "li##{dom_id(goal)}", text: "Delete"
    end
  end

  test "admin can see own goal detail " do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.goals.first.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "admin can see employee goal details" do
    sign_out @employee
    @admin = users(:super)
    sign_in @admin
    @employee = users(:member)
    visit page_detail_url
    assert_selector "h3", text: @employee.goals.first.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "lead can see own goals" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can not create a goal for himself
    assert_no_selector "form#new_goal"
    # can not edit, delete goal for himself
    @employee.goals.each do |goal|
      assert_selector "li##{dom_id(goal)}", text: "Show"
      assert_no_selector "li##{dom_id(goal)}", text: "Edit"
      assert_no_selector "li##{dom_id(goal)}", text: "Delete"
    end
  end

  test "lead can see subordinate goals" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can create a goal for subordinate
    assert_selector "form#new_goal"
    # can edit goals for subordinates
    # can delete goals create by him
    @employee.goals.each do |goal|
      assert_selector "li##{dom_id(goal)}", text: "Show"
      assert_selector "li##{dom_id(goal)}", text: "Edit"
      if goal.user == @lead
        assert_selector "li##{dom_id(goal)}", text: "Delete"
      end
    end
  end

  test "lead can not see someone elses goals" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "lead can see own goal details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.goals.first.title
    #can not comment on goal
    assert_no_selector "textarea#comment"
  end

  test "lead can see subordinate goal details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    visit page_detail_url
    assert_selector "h3", text: @employee.goals.first.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "lead can not see someone elses goal detail" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @lead.decorate.display_name
  end

  test "member can see his own goals" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can not create a goal
    assert_no_selector "form#new_goal"
    # can see goal detail button
    # can not see edit delete button
    @employee.goals.each do |goal|
      assert_selector "li##{dom_id(goal)}", text: "Show"
      assert_no_selector "li##{dom_id(goal)}", text: "Edit"
      assert_no_selector "li##{dom_id(goal)}", text: "Delete"
    end
  end

  test "member can see his own goal details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @employee.goals.first.title
    #can not comment on goal
    assert_no_selector "textarea#comment"
  end

  test "member can not see someone elses goals" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @member.decorate.display_name
  end

  test "member can not see someone elses goal details" do
    sign_out @employee
    @member = users(:member)
    sign_in @member
    @employee = users(:admin)
    visit page_detail_url
    assert_selector "h1", text: @member.decorate.display_name
  end
end
