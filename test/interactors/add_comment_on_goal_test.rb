require "test_helper"

class AddCommentonGoalTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @goal = @user.goals.first
    @actor = users(:actor)
    @params = { user_id: @actor.id, commentable_id: @goal.id, title: "this is a new goal", status: "stale" }
    @method = "and mark Missed"
  end

  test "can comment on goal" do
    comment = AddCommentOnGoal.call(@params, @goal, @method, @actor).result
    assert comment
    assert_equal comment.user_id, @actor.id
    goal = @user.goals.first
    assert_equal goal.status, "missed"
  end
end
