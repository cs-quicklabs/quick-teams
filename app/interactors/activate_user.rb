class ActivateUser < Patterns::Service
  def initialize(user, actor)
    @user = user
    @actor = actor
  end

  def call
    activate
    add_event
    user
  rescue StandardError
    user
  end

  private

  attr_reader :user, :actor

  def activate
    user.update!(active: true, deactivated_on: nil)
  end

  def add_event
    user.events.create!(user: actor, action: "activated", action_for_context: "activated", trackable: user)
  end
end
