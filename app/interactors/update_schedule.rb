class UpdateSchedule < Patterns::Service
  def initialize(schedule, project, employee, params, actor)
    @schedule = schedule
    @project = project
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    update_schedule
    add_event
    schedule
  end

  private

  def update_schedule
    schedule.update(params)
    schedule.project = @project
    schedule.save!
  end

  def add_event
    project.events.create(user: actor, action: "scheduled", action_for_context: "with #{schedule.occupancy}% occupancy till #{schedule.ends_at.to_date.to_s(:long)}", trackable: schedule)
  end

  attr_reader :project, :actor, :schedule, :employee, :params
end
