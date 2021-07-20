require "application_system_test_case"
require "nokogiri"

class EmployeeScheduleTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  setup do
    @employee = users(:regular)
    @account = @employee.account
    ActsAsTenant.current_tenant = @account
    sign_in @employee
  end

  def page_url
    employee_schedules_url(script_name: "/#{@account.id}", employee_id: @employee.id)
  end

  test "admin can see schedule" do
  end

  test "member can see his schedule" do
  end

  test "member can not see someone elsees schedule" do
  end

  test "lead can see his schedule" do
  end

  test "lead can see schedule of his subordinates" do
  end

  test "lead can not see schedule of other employees" do
  end
end
