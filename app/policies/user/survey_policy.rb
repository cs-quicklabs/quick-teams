class User::SurveyPolicy < User::BaseUserPolicy
  def destroy?
    is_active?
  end
end
