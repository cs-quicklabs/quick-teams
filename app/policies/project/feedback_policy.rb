class Project::FeedbackPolicy < Project::BaseProjectPolicy
  def update?
    user.admin?
  end

  def show?
    user.admin? or user.is_manager?(record.first)
  end

  def edit?
    user.admin? or (user.is_manager?(record.first) and record.last.user == user)
  end

  def destroy?
    user.admin? or (user.is_manager?(record.first) and record.last.user == user)
  end
end
