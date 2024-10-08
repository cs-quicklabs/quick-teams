class Survey::BaseController < BaseController
  before_action :set_survey, only: %i[show edit update destroy]
  include Pagy::Backend
  helper_method :resolve_redirect_path

  private

  def resolve_redirect_path(attempt)
    if attempt.survey.survey_for == "project"
      attempt.survey.kpi? ? project_kpis_path(attempt.participant) : project_surveys_path(attempt.participant)
    elsif attempt.survey.survey_for == "user"
      attempt.survey.kpi? ? employee_kpis_path(attempt.participant) : employee_surveys_path(attempt.participant)
    elsif attempt.survey.survey_for == "adhoc"
      survey_attempts_path(attempt.survey)
    end
  end

  def set_survey
    @survey ||= Survey::Survey.find(params[:id])
  end
end

class String
  def resolve_class
    klass = self
    if self == "adhoc"
      klass = "user"
    end
    klass.capitalize.constantize
  end
end
