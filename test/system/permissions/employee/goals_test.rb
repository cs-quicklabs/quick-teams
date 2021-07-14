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
end
