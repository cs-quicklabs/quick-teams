class User::SurveyPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return true if user.member_in_managed_project?(employee)
    return self_or_subordinate? if user.lead?
    self?
  end
end
