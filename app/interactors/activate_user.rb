class ActivateUser < Patterns::Service
  def initialize(user, actor)
    @user = user
    @actor = actor
  end

  def call
    begin
      activate
      add_event
    rescue
      user
    end

    user
  end

  private

  def activate
    user.active = true
    user.deactivated_on = nil
    user.save!
  end

  def add_event
    user.events.create(user: actor, action: "activated", action_for_context: "deactivated", trackable: user)
  end

  attr_reader :user, :actor
end
