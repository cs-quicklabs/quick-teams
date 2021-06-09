require "test_helper"

class WeeklyActivityMailerJobTest < ActiveJob::TestCase
  test "weekly activity email is scheduled" do
    WeeklyActivityMailerJob.perform_now
  end
end
