class RemoveSchedule < Patterns::Service
  def initialize(schedule, actor)
    @schedule = schedule
    @actor = actor
    @employee = schedule.user
    @project = schedule.project
  end

  def call
    remove_schedule
    add_event
    send_email
    schedule
  rescue StandardError
    schedule
  end

  private

  attr_reader :actor, :schedule, :employee, :project

  def remove_schedule
    schedule.destroy!
    project.reset_billable_resources
  end

  def add_event
    employee.events.create!(
      user: actor,
      action: "freed",
      action_for_context: "freed",
      trackable: project,
    )
  end

  def send_email
    return unless deliver_email?

    SchedulesMailer.with(employee: employee, project: project)
                   .relieved_email
                   .deliver_later
  end

  def deliver_email?
    employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end
end
