class AddProjectReport < Patterns::Service
  def initialize(project, params, submitted, actor)
    @project = project
    @report = project.reports.new(params)
    @submitted = submitted
    @actor = actor
  end

  def call
    add_report
    add_event
    report
  rescue StandardError
    report
  end

  private

  attr_reader :project, :report, :submitted, :actor

  def add_report
    report.submitted = submitted
    report.user_id = actor.id
    report.save!
  end

  def add_event
    return unless submitted

    project.events.create!(
      user: actor,
      action: "report",
      action_for_context: "added new report in project",
      trackable: report,
    )
  end
end
