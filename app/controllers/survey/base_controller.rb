class Survey::BaseController < BaseController
  before_action :set_survey, only: %i[show edit update destroy]
  include Pagy::Backend
  helper_method :resolve_redirect_path

  private

  def resolve_redirect_path(attempt)
    if attempt.survey.survey_for == 'project'
      attempt.survey.kpi? ? project_kpis_path(attempt.participant) : project_surveys_path(attempt.participant)
    elsif attempt.survey.survey_for == 'user'
      resolve_employee_page(attempt)
    elsif attempt.survey.survey_for == 'adhoc'
      survey_attempts_path(attempt.survey)
    end
  end

  def set_survey
    @survey ||= Survey::Survey.find(params[:id])
  end

  def resolve_employee_page(attempt)
    if attempt.survey.culture?
      employee_culture_path(attempt.participant)
    elsif attempt.survey.kpi?
      employee_kpis_path(attempt.participant)
    else
      employee_surveys_path(attempt.participant)
    end
  end
end

class String
  def resolve_class
    klass = self
    klass = 'user' if self == 'adhoc'
    klass.capitalize.constantize
  end
end
