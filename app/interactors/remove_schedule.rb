class RemoveSchedule < Patterns::Service
  def initialize(schedule, actor)
    @schedule = schedule
    @actor = actor
    @employee = schedule.user
    @project = schedule.project
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
    project.reset_billable_resources
  end

  def add_event
    employee.events.create(user: actor, action: "freed", action_for_context: "freed", trackable: project)
  end

  def send_email
    SchedulesMailer.with(employee: employee, project: project).relieved_email.deliver_later if deliver_email?
  end

  def deliver_email?
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :actor, :schedule, :employee, :project
end
