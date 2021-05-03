class AddTimesheet < Patterns::Service
  def initialize(params, actor)
    @timesheet = Timesheet.new(params)
    @project = Project.find(params["project_id"])
    @actor = actor
  end

  def call
    begin
      create_timesheet
    rescue
      timesheet
    end

    timesheet
  end

  private

  def create_timesheet
    timesheet.billable = project.billable
    timesheet.user = actor
    timesheet.save!
  end

  attr_reader :project, :actor, :timesheet
end
