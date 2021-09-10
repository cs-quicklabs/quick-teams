class User::KpiPolicy < User::BaseUserPolicy
  def index?
    true
  end
end
