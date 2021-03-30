require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @role = roles(:senior)
    @job = jobs(:ios)
    @discipline = disciplines(:engineering)
  end

  test "should have account" do
    user = User.new
    user.valid?
    assert_not user.errors[:account].empty?
  end

  test "should have active users in active scope" do
    users = User.active
    users.each do |user|
      assert user.active
    end
  end

  test "should have inactive users in inactive scope" do
    users = User.inactive
    users.each do |user|
      assert_not user.active
    end
  end

  test "should have current account users in current account scope" do
    current_account = accounts(:crownstack)
    Current.account = current_account
    users = User.for_current_account
    users.each do |user|
      assert_equal user.account, current_account
    end
  end

  test "should have email" do
    user = User.new
    user.valid?
    assert_not user.errors[:email].empty?
  end

  test "should have first name" do
    user = User.new
    user.valid?
    assert_not user.errors[:first_name].empty?
  end

  test "should have last name" do
    user = User.new
    user.valid?
    assert_not user.errors[:last_name].empty?
  end

  test "should not require manager" do
    user = User.new
    user.valid?
    assert user.errors[:manager].empty?
  end

  test "should have discipline" do
    user = User.new
    user.valid?
    assert_not user.errors[:discipline].empty?
  end

  test "should have role" do
    user = User.new
    user.valid?
    assert_not user.errors[:role].empty?
  end

  test "should have job" do
    user = User.new
    user.valid?
    assert_not user.errors[:job].empty?
  end
end
