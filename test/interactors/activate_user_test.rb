require "test_helper"

class ActivateUserTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:inactive)
    @actor = users(:actor)
  end

  test "can activate user" do
    user = ActivateUser.call(@user, @actor).result
    assert user
    assert user.active
    assert_nil user.deactivated_on
  end

  test "can add event activated" do
    assert_difference("@user.events.count") do
      ActivateUser.call(@user, @actor)
    end
    assert_equal Event.last.action, "activated"
  end
end
