class Project::ClientPolicy < Project::BaseProjectPolicy
  def delete?
    is_active?
  end
end
