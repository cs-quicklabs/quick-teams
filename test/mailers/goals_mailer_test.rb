require "test_helper"

class GoalsMailerTest < ActionMailer::TestCase
  def setup
    @actor = users(:actor)
    @employee = users(:regular)
    @goal = goals(:one)
  end

  test "welcome" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).created_email
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.com"]
    assert_equal email.subject, "New Goal Created"
    assert_match "Show Goal", email.body.encoded
  end
end
