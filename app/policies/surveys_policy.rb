class SurveysPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
