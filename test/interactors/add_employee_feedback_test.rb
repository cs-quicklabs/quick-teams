require "test_helper"

class AddEmployeeFeedbackTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @params = { title: "some new feedback", body: "feedback body" }
    @actor = users(:actor)
  end

  test "can add feedback" do
    feedback = AddEmployeeFeedback.call(@user, @params, @actor).result
    assert feedback
    assert_equal feedback.user_id, @actor.id
  end

  test "can add event feedback" do
    assert_difference("@user.events.count") do
      AddEmployeeFeedback.call(@user, @params, @actor)
    end
    assert_equal Event.last.action, "feedback"
  end
end
