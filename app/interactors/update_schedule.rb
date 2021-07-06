class UpdateSchedule < Patterns::Service
  def initialize(schedule, project, employee, params, actor)
    @schedule = schedule
    @project = project
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    begin
      update_schedule
      update_billable_resources
      add_event
      send_email
    rescue
      schedule
    end
    schedule
  end

  private

  def update_schedule
    schedule.update(params)
    schedule.project = @project
    schedule.user = @employee
    schedule.save!
  end

  def update_billable_resources
    project.billable_resources = billable_resources
    project.save!
  end

  def billable_resources
    project.schedules.reduce(0.0) do |sum, schedule|
      sum += schedule.billable ? (schedule.occupancy/100.0) : 0
      sum
    end
  end

  def add_event
    project.events.create(user: actor, action: "scheduled", action_for_context: context, trackable: employee)
  end

  def send_email
    message = context + " in project #{project.name}"
    SchedulesMailer.with(employee: employee, message: message).updated_email.deliver_later if deliver_email?
  end

  def deliver_email?
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  def context
    "with #{schedule.occupancy}% occupancy till #{schedule.ends_at.to_date.to_s(:long)}"
  end

  attr_reader :project, :actor, :schedule, :employee, :params
end
