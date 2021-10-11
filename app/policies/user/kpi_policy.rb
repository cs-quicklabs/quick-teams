class User::KpiPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def stats?
    index?
  end
end
