class Project::FeedbackPolicy < Project::BaseProjectPolicy
  def update?
    user.admin?
  end

  def show?
    user.admin? or user.is_manager?(record.first)
  end
end
