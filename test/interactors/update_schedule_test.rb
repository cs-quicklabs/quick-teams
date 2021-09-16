require "test_helper"

class UpdateScheduleTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @schedule = Schedule.new
    @project = projects(:one)
    @employee = users(:regular)
    @actor = users(:actor)
    @params = { user_id: @employee.id, starts_at: "2021-03-26", ends_at: "2021-04-01", occupancy: 100, billable: true }
  end

  test "can update schedule" do
    schedule = UpdateSchedule.call(@schedule, @project, @employee, @params, @actor).result
    assert schedule
    assert_equal schedule.project, @project
  end

  test "can add event scheduled" do
    assert_difference("@project.events.count") do
      UpdateSchedule.call(@schedule, @project, @employee, @params, @actor)
    end
    assert_equal Event.last.action, "scheduled"
  end

  test "can send email" do
    assert_emails 1 do
      UpdateSchedule.call(@schedule, @project, @employee, @params, @actor)
    end
  end
end
