class User::AboutPolicy < User::BaseUserPolicy
  def index?
    is_admin? or is_project_manager? or is_team_lead? or self?
  end

  def edit?
    self? or is_admin? && is_active?
  end

  def update?
    edit?
  end
end
