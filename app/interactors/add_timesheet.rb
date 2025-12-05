class AddTimesheet < Patterns::Service
  def initialize(params, actor)
    @timesheet = Timesheet.new(params)
    @project = Project.find(params["project_id"])
    @actor = actor
  end

  def call
    create_timesheet
    timesheet
  rescue StandardError
    timesheet
  end

  private

  attr_reader :project, :actor, :timesheet

  def create_timesheet
    timesheet.billable = project.billable && actor.billable
    timesheet.user = actor
    timesheet.save!
  end
end
