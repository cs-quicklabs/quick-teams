require "application_system_test_case"

class ProjectMilestonesTest < ApplicationSystemTestCase
  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    @project = projects(:managed)
    sign_in @employee
  end

  def page_url
    project_milestones_url(script_name: "/#{@account.id}", project_id: @project.id)
  end

  def page_detail_url
    project_milestone_url(script_name: "/#{@account.id}", project_id: @project.id, id: @project.milestones.first.id)
  end

  test "admin can see project milestones" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Milestones"
    assert_selector "form#new_goal"
    milestone = @project.milestones.first
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Show"
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Edit"
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Delete"
    milestone = @project.milestones.last
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Show"
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Edit"
    assert_selector "div#buttons_#{dom_id(milestone)}", text: "Delete"
  end

  test "admin can see project milestone details" do
    sign_out @employee
    @employee = users(:super)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#milestone-detail"
  end

  test "lead can not see project milestone" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Milestones"
    assert_no_selector "form#new_goal"
  end

  test "lead can not see project milestone details" do
    sign_out @employee
    @employee = users(:lead)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#milestone-detail"
  end

  test "member can not see project milestone" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Milestones"
    assert_no_selector "form#new_goal"
  end

  test "member can not see project milestones details" do
    sign_out @employee
    @employee = users(:member)
    sign_in @employee
    visit page_detail_url
    assert_no_selector "div#milestone-detail"
  end

  test "manager can see project milestones" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_url
    assert_selector "div#project-tabs", text: "Milestones"
    assert_selector "form#new_goal"
    milestones = @project.milestones
    milestones.each do |milestone|
      if milestone.user_id == @employee.id
        assert_selector "div#buttons_#{dom_id(milestone)}", text: "Show"
        assert_selector "div#buttons_#{dom_id(milestone)}", text: "Edit"
        assert_selector "div#buttons_#{dom_id(milestone)}", text: "Delete"
      else
        assert_selector "div#buttons_#{dom_id(milestone)}", text: "Show"
        assert_no_selector "div#buttons_#{dom_id(milestone)}", text: "Edit"
        assert_no_selector "div#buttons_#{dom_id(milestone)}", text: "Delete"
      end
    end
  end

  test "manager can see project milestone details" do
    sign_out @employee
    @employee = users(:manager)
    sign_in @employee
    visit page_detail_url
    assert_selector "div#milestone-detail"
  end

  test "manager can not see project milestones for different project" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    sign_in @employee
    visit page_url
    assert_no_selector "div#project-tabs", text: "Milestones"
  end

  test "manager can not see project milestone details of different project" do
    sign_out @employee
    @employee = users(:manager)
    @project = projects(:one)
    @milestone = @project.milestones.first
    sign_in @employee
    visit page_url
    assert_no_selector "div#milestone-detail"
  end
end
