class AddProjectReport < Patterns::Service
  def initialize(project, params, param, actor)
   @project = project
    @report = @project.reports.new params
      @param= param
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
    if param[:draft]
         report.submitted = false
      else
    report.submitted = true
    end
    report.save!
  end
  
  def add_event
    project.events.create(user: actor, action: "report", action_for_context: "added new report in project", trackable: report)
  end

  attr_reader :project, :report, :param, :actor
end
