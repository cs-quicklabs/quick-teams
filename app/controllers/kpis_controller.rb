class KpisController < BaseController
  def index
    authorize :kpis
    @kpis = Survey::Survey.where(survey_type: :kpi).order(:name)
  end
end
