class User::SurveyPolicy < User::BaseUserPolicy
  def delete?
    is_active?
  end
end
