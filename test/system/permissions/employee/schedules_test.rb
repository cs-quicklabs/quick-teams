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
end
