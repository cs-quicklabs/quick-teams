class DeactivateUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    remove_as_manager
    remove_reporting_manager
    clear_schedules
    deactivate
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

  attr_reader :user
end
