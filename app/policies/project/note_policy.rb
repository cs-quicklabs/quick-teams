class Project::NotePolicy < Project::BaseProjectPolicy
  def update?
    note = record.last
    user.admin? or note.user_id == user.id
  end

  def create?
    project = record.first
    user.admin? or user.is_manager?(project)
  end

  def destroy?
    note = record.last
    user.admin? or note.user_id == user.id
  end

  def edit?
    note = record.last
    user.admin? or note.user_id == user.id
  end
end
