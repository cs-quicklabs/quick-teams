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

  test "admin can see his feedbacks" do
  end

  test "admin can see someone elses feedback" do
  end

  test "admin can see feedback details" do
  end

  test "lead can see his feedbacks" do
  end

  test "lead can see his subordinates feedback" do
  end

  test "lead can not see someone elsese feedback" do
  end

  test "lead can see his feedback details" do
  end

  test "lead can see his subordinates feedback details" do
  end

  test "lead can not see someone elses feedback details" do
  end

  test "member can see his feedbacks" do
  end

  test "member can see his feedback details" do
  end

  test "member can not see someone elses feedback" do
  end

  test "member can not see someone elses feedback details" do
  end

  test "admin can see unpublished feedbacks" do
  end

  test "lead can not see his own unfinished feedback" do
  end

  test "lead can see unfinished feedback for his subordinates" do
  end

  test "member can not see unpublished feedback" do
  end
end
