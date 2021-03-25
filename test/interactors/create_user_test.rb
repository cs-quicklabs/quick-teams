require "test_helper"

class CreateUserTest < ActiveSupport::TestCase
  setup do
    @params = { first_name: "Aashish", last_name: "Dhawan", email: "aashish@crownstack.com", role: roles(:senior), job: jobs(:ios), discipline: disciplines(:engineering) }
    @actor = users(:actor)
    @account = accounts(:crownstack)
  end

  test "can create user" do
    user = CreateUser.call(@params, @actor, @account).result
    assert user.save
    assert_equal user.account, accounts(:crownstack)
  end

  test "can add event created" do
    assert_difference("Event.count") do
      CreateUser.call(@params, @actor, @account)
    end
    assert_equal Event.last.action, "created"
  end
end
