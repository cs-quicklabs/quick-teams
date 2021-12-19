class UpdateReport < Patterns::Service
  def initialize(report, params, submitted)
    @report = report
    @submitted = submitted
    @params = params.merge(submitted: submitted)
    @reportable = @report.reportable
    @actor = @report.user
  end

  def call
    begin
      update_report
      add_event
    rescue
      report
    end

    report
  end

  private

  def update_report
    report.update(params)
  end

  def add_event
    reportable.events.create(user: actor, action: "report", action_for_context: "added new report in project", trackable: report) if submitted
  end

  attr_reader :report, :submitted, :params, :actor, :reportable
end
