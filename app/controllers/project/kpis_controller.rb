class Project::KpisController < Project::BaseController
  before_action :set_project, only: [:stats, :index]

  def index
    authorize [@project, :kpi]

    @kpi = @project.kpi

    unless @kpi.nil?
      fresh_when @kpi.attempts.where(participant_id: @project.id, participant_type: "Project") + [@project]
    end
  end

  def stats
    authorize [@project, :kpi]

    @kpi = @project.kpi
    unless @kpi.nil?
      @stats = Survey::Stats::SurveyParticipantStats.new(@kpi, @project)
    end

    render "shared/surveys/stats"
  end
end
