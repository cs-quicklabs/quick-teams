class Project::NotePolicy < Project::BaseProjectPolicy
  def update?
    project = record.first
    note = record.last
    (user.admin? or note.user_id == user.id) and not project.archived?
  end

  def create?
    project = record.first
    return false if project.archived?
    return true if user.admin?
    user.is_manager?(project)
  end

  def destroy?
    project = record.first
    note = record.last
    return false if project.archived?
    return true if user.admin?
    note.user_id == user.id
  end

  def edit?
    project = record.first
    note = record.last
    return false if project.archived?
    return true if user.admin?
    (note.user_id == user.id)
  end
end
