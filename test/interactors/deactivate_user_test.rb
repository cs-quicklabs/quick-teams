require "test_helper"

class DeactivateUserTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:regular)
    @actor = users(:actor)
  end

  test "can deactivate user" do
    user = DeactivateUser.call(@user, @actor).result
    assert user
    assert_not user.active
    assert_not_nil user.deactivated_on
  end

  test "can add event" do
    assert_difference("@user.events.count") do
      DeactivateUser.call(@user, @actor)
    end
    assert_equal Event.last.action, "deactivated"
  end

  test "can clear schedules" do
    user = DeactivateUser.call(@user, @actor).result
    assert Schedule.where(user: user).count == 0
  end

  test "can remove as manager" do
    user = DeactivateUser.call(@user, @actor).result
    assert user.subordinates.count == 0
  end

  test "can remove reporting manager" do
    user = DeactivateUser.call(@user, @actor).result
    assert_nil user.manager
  end
end
