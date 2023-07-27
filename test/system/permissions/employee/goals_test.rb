require "application_system_test_case"

class EmployeeGoalsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @actor = users(:actor)
    @account = @actor.account
    ActsAsTenant.current_tenant = @account
    @employee = users(:regular)
    @goal = @employee.goals.where(permission: false).first
    @second = @employee.goals.where(permission: true).first
    sign_in @actor
  end

  def page_url
    employee_goals_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  def page_detail_url
    employee_goal_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @goal.id)
  end

  def second_page_detail_url
    employee_goal_url(script_name: "/#{@account.id}", employee_id: @employee.id, id: @second.id)
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
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
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
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
    end
  end

  test "admin can see own goal detail " do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "admin can see employee goal details" do
    sign_out @employee
    @admin = users(:super)
    sign_in @admin
    @employee = users(:member)
    visit page_detail_url
    assert_selector "h3", text: @goal.title
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
    # can create a goal for himself
    assert_selector "form#new_goal"
    # can  edit, delete goal for himself
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
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
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      if goal.user == @lead
        assert_selector "tr##{dom_id(goal)}", text: "Delete"
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
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "lead can see subordinate goal details" do
    sign_out @employee
    @lead = users(:lead)
    sign_in @lead
    @employee = @lead.subordinates.first
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h3", text: @goal.title
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
    # can create a goal
    assert_selector "form#new_goal"
    # can see goal detail button
    # can  see edit delete button
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
    end
  end

  test "member can see his own goal details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
    visit second_page_detail_url
    assert_selector "h3", text: @second.title
    #can comment on goal
    assert_selector "textarea#comment"
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

  test "project manager can see own goals" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can create a goal for himself
    assert_selector "form#new_goal"
    # can  edit, delete goal for himself
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
    end
  end

  test "project manager can see project participant goals" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can create a goal for subordinate
    assert_selector "form#new_goal"
    # can edit goals for subordinates
    # can delete goals create by him
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      if goal.user == @lead
        assert_selector "tr##{dom_id(goal)}", text: "Delete"
      end
    end
  end

  test "project manager can not see someone elses goals" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project manager can see own goal details" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "project manager can see project participant goal details" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:regular)
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "project manager can not see someone elses goal detail" do
    sign_out @employee
    @manager = users(:manager)
    sign_in @manager
    @employee = users(:admin)
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project observer can see own goals" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can create a goal for himself
    assert_selector "form#new_goal"
    # can  edit, delete goal for himself
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      assert_selector "tr##{dom_id(goal)}", text: "Delete"
    end
  end

  test "project observer can see project participant goals" do
    sign_out @employee
    @manager = users(:abram)
    sign_in @manager
    @employee = users(:actor)
    visit page_url
    assert_selector "h1", text: @employee.decorate.display_name
    assert_selector "div#employee-tabs", text: "Goals"
    # can create a goal for subordinate
    assert_selector "form#new_goal"
    # can edit goals for subordinates
    # can delete goals create by him
    @employee.goals.each do |goal|
      assert_selector "tr##{dom_id(goal)}", text: "Edit"
      if goal.user == @lead
        assert_selector "tr##{dom_id(goal)}", text: "Delete"
      end
    end
  end

  test "project observer can not see someone elses goals" do
    sign_out @employee
    @manager = users(:abram)
    sign_in @manager
    @employee = users(:admin)
    visit page_url
    assert_selector "h1", text: @manager.decorate.display_name
  end

  test "project observer can see own goal details" do
    sign_out @employee
    @employee = users(:abram)
    sign_in @employee
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "project observer can see project participant goal details" do
    sign_out @employee
    @manager = users(:abram)
    sign_in @manager
    @employee = users(:actor)
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h3", text: @goal.title
    #can comment on goal
    assert_selector "textarea#comment"
  end

  test "project observer can not see someone elses goal detail" do
    sign_out @employee
    @manager = users(:abram)
    sign_in @manager
    @employee = users(:admin)
    @goal = @employee.goals.where(permission: false).first
    visit page_detail_url
    assert_selector "h1", text: @manager.decorate.display_name
  end
end
