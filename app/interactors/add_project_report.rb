class AddProjectReport < Patterns::Service
  def initialize(project, params)
   @project = project
    @report = @project.reports.new params
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
    report.submitted = true
    report.save!
  end
  
  def add_event
    project.events.create(user: actor, action: "reviewed", action_for_context: "added new report in project", trackable: report)
  end

  attr_reader :prject, :report, :actor
end
