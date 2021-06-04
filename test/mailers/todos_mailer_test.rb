require "test_helper"

class TodosMailerTest < ActionMailer::TestCase
  def setup
    @employee = users(:regular)
    @actor = users(:actor)
  end

  test "added" do
    email = TodosMailer.with(employee: @employee, actor: @actor).added_email
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "New TODO Assigned"
    assert_match "Show TODOs", email.body.encoded
  end

  test "completed" do
    email = TodosMailer.with(employee: @employee, actor: @actor).completed_email
    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [@actor.email]
    assert_equal email.from, ["admin@skia.me"]
    assert_equal email.subject, "TODO Completed"
    assert_match "Show TODOs", email.body.encoded
  end
end
