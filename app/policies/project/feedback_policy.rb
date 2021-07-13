class Project::FeedbackPolicy < Project::BaseProjectPolicy
  def update?
    user.admin? or record.last.user == user
  end
end
