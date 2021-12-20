require "test_helper"

class CommentsMailerTest < ActionMailer::TestCase
  def setup
    @actor = users(:actor)
    @employee = users(:regular)
    @report = reports(:one)
  end

  test "commented" do
    email = CommentsMailer.with(actor: @actor, employee: @employee, report: @report).commented_email
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "New Comment on Report"
    assert_match "Show Report", email.body.encoded
  end
end
