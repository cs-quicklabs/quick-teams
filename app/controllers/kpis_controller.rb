class KpisController < SurveysController
  before_action :set_survey, only: %i[ show edit update destroy clone ]

  def index
    authorize :kpis
    @pagy, @surveys = pagy_nil_safe(params, Survey::Survey.where(survey_type: :Kpi).order(:name), items: LIMIT)
  end
end
