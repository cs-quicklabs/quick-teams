require "test_helper"

class SchedulesMailerTest < ActionMailer::TestCase
  def setup
    @employee = users(:regular)
  end

  test "updated" do
    email = SchedulesMailer.with(employee: @employee, message: "with 100% occupancy in project Gotasker").updated_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "Schedule Updated"
    assert_match "Show Schedule", email.body.encoded
  end

  test "relieved" do
    email = SchedulesMailer.with(employee: @employee, project: projects(:one)).relieved_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "Relieved From Project"
    assert_match "Show Schedule", email.body.encoded
  end
end
