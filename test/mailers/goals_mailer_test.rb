require "test_helper"

class GoalsMailerTest < ActionMailer::TestCase
  def setup
    @actor = users(:actor)
    @employee = users(:regular)
    @goal = goals(:one)
  end

  test "created" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).created_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "New Goal Created"
    assert_match "Show Goal", email.body.encoded
  end

  test "commented" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).commented_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "New Comment on Goal"
    assert_match "Show Goal", email.body.encoded
  end

  test "missed" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).missed_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "Goal Missed"
    assert_match "Show Goal", email.body.encoded
  end

  test "completed" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).completed_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "Goal Completed"
    assert_match "Show Goal", email.body.encoded
  end

  test "discarded" do
    email = GoalsMailer.with(actor: @actor, employee: @employee, goal: @goal).discarded_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "Goal Discarded"
    assert_match "Show Goal", email.body.encoded
  end
end
