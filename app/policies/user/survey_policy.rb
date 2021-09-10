class User::SurveyPolicy < User::BaseUserPolicy
  def index?
    true
  end
end
