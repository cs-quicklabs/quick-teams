class UpdateReport < Patterns::Service
  def initialize(report, params, submitted)
    @report = report
    @submitted = submitted
    @params = params.merge(submitted: submitted)
    @reportable = report.reportable
    @actor = report.user
  end

  def call
    update_report
    add_event
    report
  rescue StandardError
    report
  end

  private

  attr_reader :report, :submitted, :params, :actor, :reportable

  def update_report
    report.update!(params)
  end

  def add_event
    return unless submitted

    reportable.events.create!(
      user: actor,
      action: "report",
      action_for_context: "added new report in project",
      trackable: report,
    )
  end
end
