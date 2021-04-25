class Project::SchedulePolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    return true if user.admin?

    record.all { |schedule| schedule.user_id == user.id }
  end
end
