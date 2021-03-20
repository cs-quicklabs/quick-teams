class ActivateUser < Patterns::Service
  def initialize(user, actor)
    @user = user
    @actor = actor
  end

  def call
    activate
    add_event
  end

  private

  def activate
    user.active = true
    user.deactivated_on = nil
    user.save
  end

  def add_event
    user.events.create(user: actor, action: "deactivated user.", action_for_context: "deactivated")
  end

  attr_reader :user, :actor
end
