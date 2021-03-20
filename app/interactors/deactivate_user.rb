class DeactivateUser < Patterns::Service
  def initialize(user, actor)
    @user = user
    @actor = actor
  end

  def call
    remove_as_manager
    remove_reporting_manager
    clear_schedules
    deactivate
    add_event
  end

  private

  def remove_as_manager
    user.subordinates.update_all(manager_id: nil)
  end

  def remove_reporting_manager
    user.update(manager_id: nil)
  end

  def clear_schedules
    Schedule.where(user: user).destroy_all
  end

  def deactivate
    user.active = false
    user.deactivated_on = Time.now
    user.save
  end

  def add_event
    user.events.create(user: actor, action: "deactivated project.", action_for_context: "deactivated project")
  end

  attr_reader :user, :actor
end
