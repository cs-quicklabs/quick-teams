require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    ActsAsTenant.current_tenant = accounts(:crownstack)
    @project = projects(:one)
    @user = users(:regular)
    @actor = users(:actor)
  end

  test "should have account" do
    ActsAsTenant.current_tenant = nil
    assert_raises ActsAsTenant::Errors::NoTenantSet do
      event = @project.events.new(action: "reviewed", eventable: @project, trackable: @user)
      role.save
    end
  end

  test "should have user" do
    assert_raises ActiveRecord::NotNullViolation, ActiveRecord::RecordInvalid do
      event = @project.events.new(action: "reviewed", eventable: @project, trackable: @user)
      event.save!
    end
  end

  test "should have eventable" do
    event = Event.new
    event.valid?
    assert_not event.errors[:eventable].empty?
  end

  test "should have trackable" do
    event = Event.new
    event.valid?
    assert_not event.errors[:trackable].empty?
  end

  test "should have valid action" do
    event = @project.events.new(action: "random", eventable: @project, trackable: @user)
    event.valid?
    assert_not event.errors[:action].empty?

    event = @project.events.new(action: Event::ACTIONS.first, eventable: @project, trackable: @user)
    event.valid?
    assert_empty event.errors[:action]
  end
end
