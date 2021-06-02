require "test_helper"

class RemoveScheduleTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @schedule = schedules(:one)
    @actor = users(:actor)
  end

  test "can remove schedule" do
    assert_difference("Schedule.count", -1) do
      RemoveSchedule.call(@schedule, @actor)
    end
  end

  test "can add event" do
    assert_difference("Event.count") do
      RemoveSchedule.call(@schedule, @actor)
    end
  end

  test "can send email" do
    assert_emails 1 do
      RemoveSchedule.call(@schedule, @actor)
    end
  end
end
