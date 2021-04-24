require "test_helper"

class AddEmployeeGoalTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @params = { title: "some new goal", deadline: "2021-04-01", body: "goal body" }
    @actor = users(:actor)
  end

  test "can add goal" do
    goal = AddEmployeeGoal.call(@user, @params, @actor).result
    assert goal
    assert_equal goal.user_id, @actor.id
  end

  test "can add event goal" do
    assert_difference("@user.events.count") do
      AddEmployeeGoal.call(@user, @params, @actor)
    end
    assert_equal Event.last.action, "goal"
  end
end
