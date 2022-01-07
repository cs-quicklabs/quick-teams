class Employee::KpisController < Employee::BaseController
  before_action :set_employee, only: [:stats, :index]

  def index
    authorize [@employee, :kpi]

    @kpi = @employee.kpi

    unless @kpi.nil?
      fresh_when @kpi.attempts.where(participant_id: @employee.id, participant_type: "User") + [@employee]
    end
  end

  def stats
    authorize [@employee, :kpi]

    @kpi = @employee.kpi
    @show_own_attempts = false
    unless @kpi.nil?
      @stats = Survey::Stats::EmployeeKpiStats.new(@kpi, @employee, @show_own_attempts)
    end

    render "shared/surveys/stats"
  end
end
