class Project::NotePolicy < Project::BaseProjectPolicy
  def edit?
    note = record.last
    (is_admin? or note.user == user) and is_active?
  end
end
