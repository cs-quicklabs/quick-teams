require "test_helper"

class DailyTechNuggetMailerJobTest < ActiveJob::TestCase
  test "daily tech nugget email is scheduled" do
    DailyTechNuggetMailerJob.perform_now
  end
end
