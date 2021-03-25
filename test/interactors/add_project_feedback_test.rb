require "test_helper"

class AddProjectFeedbackTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:one)
    @params = { title: "Feedback title", body: "Feedback Body" }
    @actor = users(:actor)
  end

  test "can add feedback" do
    feedback = AddProjectFeedback.call(@project, @params, @actor).result
    assert feedback
    assert_equal feedback.user_id, @actor.id
  end

  test "can add event reviewed" do
    assert_difference("@project.events.count") do
      AddProjectFeedback.call(@project, @params, @actor)
    end
    assert_equal Event.last.action, "reviewed"
  end
end
