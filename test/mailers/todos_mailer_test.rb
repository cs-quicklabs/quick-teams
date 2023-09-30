require "test_helper"

class TodosMailerTest < ActionMailer::TestCase
  def setup
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @employee = users(:regular)
    @actor = users(:actor)
    @todo = @employee.todos.first
  end

  test "added" do
    email = TodosMailer.with(employee: @employee, actor: @actor, todo: @todo).added_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "New TODO Assigned"
    assert_match "Show TODO", email.body.encoded
  end

  test "completed" do
    email = TodosMailer.with(employee: @employee, actor: @actor, todo: @todo).completed_email
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal email.to, [@employee.email]
    assert_equal email.from, ["admin@quicklabs.in"]
    assert_equal email.subject, "TODO Completed"
    assert_match "Show TODO", email.body.encoded
  end
end
