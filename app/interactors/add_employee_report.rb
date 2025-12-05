class AddEmployeeReport < Patterns::Service
  def initialize(employee, params, submitted, actor)
    @employee = employee
    @report = employee.reports.new(params)
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

  attr_reader :employee, :report, :submitted, :actor

  def add_report
    report.submitted = submitted
    report.user_id = actor.id
    report.save!
  end

  def add_event
    return unless submitted

    employee.events.create!(
      user: actor,
      action: "report",
      action_for_context: "added new report in employee",
      trackable: report,
    )
  end
end
