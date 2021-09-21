require "test_helper"

class WeeklyNuggetResetMailerJobTest < ActiveJob::TestCase
  test "unread nuggets should reset on weekly basis" do
    WeeklyNuggetResetMailerJob.perform_now
  end
end
