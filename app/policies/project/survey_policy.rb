class Project::SurveyPolicy < Project::BaseProjectPolicy
  def take?
    create?
  end
end
