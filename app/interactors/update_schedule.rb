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
    update_billable_resources
    add_event
    send_email
    schedule
  rescue StandardError
    schedule
  end

  private

  attr_reader :project, :actor, :schedule, :employee, :params

  def update_schedule
    schedule.update(params)
    schedule.project = project
    schedule.user = employee
    schedule.save!
  end

  def update_billable_resources
    project.reset_billable_resources
    schedule.update!(billable: false) unless project.billable
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "scheduled",
      action_for_context: context,
      trackable: employee,
    )
  end

  def send_email
    return unless deliver_email?

    message = "#{context} in project #{project.name}"
    SchedulesMailer.with(employee: employee, message: message)
                   .updated_email
                   .deliver_later
  end

  def deliver_email?
    employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end

  def context
    "with #{schedule.occupancy}% occupancy till #{schedule.ends_at.to_date.to_fs(:long)}"
  end
end
