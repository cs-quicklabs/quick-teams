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
    project
  end

  private

  def update_schedule
    schedule.update(params)
    schedule.project = @project
    schedule.save!
  end

  def add_event
    project.events.create(user: actor, action: "updated schedule.", action_for_context: "updated schedule")
    employee.events.create(user: actor, action: "updated schedule.", action_for_context: "updated schedule")
  end

  attr_reader :project, :actor, :schedule, :employee, :params
end
