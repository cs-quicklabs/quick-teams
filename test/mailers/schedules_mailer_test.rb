require "test_helper"

class SchedulesMailerTest < ActionMailer::TestCase
  def setup
    @employee = users(:regular)
  end

  test "updated" do
    email = SchedulesMailer.with(employee: @employee, message: "with 100% occupancy in project Gotasker").updated_email
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.com"]
    assert_equal email.subject, "Schedule Updated"
    assert_match "Show Schedule", email.body.encoded
  end
end
