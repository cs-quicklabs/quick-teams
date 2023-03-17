class Project::FeedbackPolicy < Project::BaseProjectPolicy
  def update?
    project = record.first
    user.admin? and not project.archived?
  end

  def show?
    project = record.first
    user.admin? or user.is_manager?(project) or user.is_observer?(project)
  end

  def edit?
    project = record.first
    feedback = record.last
    return false if project.archived?
    return true if user.admin?

    (user.is_observer?(project) or user.is_manager?(project)) and feedback.user == user
  end

  def show_add_feedback_form?
    is_active?
  end
end
