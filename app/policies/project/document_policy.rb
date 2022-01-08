class Project::DocumentPolicy < Project::BaseProjectPolicy
  def edit?
    document = record.last
    is_active? and (is_admin? or document.user == user)
  end
end
