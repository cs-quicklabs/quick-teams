require "test_helper"

class ActivateUserTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @user = users(:inactive)
    @actor = users(:actor)
  end

  test "can activate user" do
    assert ActivateUser.call(@user, @actor)
    assert @user.active
    assert_nil @user.deactivated_on
  end

  test "can add event" do
    assert_difference("@user.events.count") do
      ActivateUser.call(@user, @actor)
    end
  end
end
