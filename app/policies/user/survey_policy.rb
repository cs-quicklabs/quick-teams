class User::SurveyPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
     return true if user.on_project_team?(record.first)
    self?
  end
end
