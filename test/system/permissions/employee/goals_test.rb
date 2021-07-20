require "application_system_test_case"
require "nokogiri"

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

  test "admin can see own goals" do
  end

  test "admin can see someone elses goals" do
  end

  test "admin can see own goal detail " do
  end

  test "admin can see employee goal details" do
  end

  test "lead can see own goals" do
  end

  test "lead can see subordinate goals" do
  end

  test "lead can not see someone elses goals" do
  end

  test "lead can see own goal details" do
  end

  test "lead can see subordinate goal details" do
  end

  test "lead can not see someone elses goal detail" do
  end

  test "member can see his own goals" do
  end

  test "member can see his own goal details" do
  end

  test "member can not see someone elses goal details" do
  end
end
