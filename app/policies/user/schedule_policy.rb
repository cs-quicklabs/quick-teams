class User::SchedulePolicy < User::BaseUserPolicy
  def create?
    # user shoud be active and
    # only admin can change schedule for other users
    is_active? and is_admin?
  end

  def edit?
    create?
  end
end
