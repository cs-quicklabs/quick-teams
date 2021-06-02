class RemoveSchedule < Patterns::Service
  def initialize(schedule, actor)
    @schedule = schedule
    @actor = actor
    @employee = schedule.user
  end

  def call
    begin
      remove_schedule
      add_event
      send_email
    rescue
      schedule
    end

    schedule
  end

  private

  def remove_schedule
    schedule.destroy
  end

  def add_event
    employee.events.create(user: actor, action: "freed", action_for_context: "freed", trackable: schedule.project)
  end

  def send_email
    SchedulesMailer.with(employee: employee, project: schedule.project).relieved_email.deliver_later
  end

  attr_reader :actor, :schedule, :employee
end
