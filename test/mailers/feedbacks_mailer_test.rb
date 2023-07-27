require "test_helper"

class FeedbacksMailerTest < ActionMailer::TestCase
  test "publish" do
    feedback = feedbacks(:one)
    employee = feedback.critiquable
    email = FeedbacksMailer.with(feedback: feedback).publish_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [employee.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "New Feedback Published"
    assert_match "Show Feedback", email.body.encoded
  end
end
