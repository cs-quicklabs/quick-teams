class AddEmployeeReport < Patterns::Service
  def initialize(employee, params, submitted, actor)
    @employee = employee
    @report = @employee.reports.new params
    @submitted = submitted
    @actor = actor
  end

  def call
    begin
      add_report
      add_event
    rescue
      report
    end

    report
  end

  private

  def add_report
    report.submitted = submitted
    report.user_id = actor.id
    report.save!
  end

  def add_event
    employee.events.create(user: actor, action: "report", action_for_context: "added new report in employee", trackable: report) if submitted
  end

  attr_reader :employee, :report, :submitted, :actor
end
