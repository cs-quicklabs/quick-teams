class Project::TodoPolicy < Project::BaseProjectPolicy
  def edit?
    todo = record.last
    (is_admin? or todo.owner == user) and not todo.completed?
  end
end
