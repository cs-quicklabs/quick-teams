class SurveysController < BaseController
  def index
    authorize :kpis
    @surveys = Survey::Survey.where.not(survey_type: :kpi).order(:name)
  end
end
