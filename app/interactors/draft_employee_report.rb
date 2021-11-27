class DraftEmployeeReport < Patterns::Service
  def initialize(employee, params)
   @employee = employee
    @report = @employee.reports.new params
  end

  def call
    begin
      draft_report
      add_event
    rescue
      report
    end

    report
  end

  private

   def draft_report
    report.submitted = false
    report.save!
  end

  def add_event
    employee.events.create(user: actor, action: "reviewed", action_for_context: "added new report in employee", trackable: report)
  end

  attr_reader :employee, :report, :actor
end
