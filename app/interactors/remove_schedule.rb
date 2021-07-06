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
      update_billable_resources
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
    employee.events.create(user: actor, action: "freed", action_for_context: "freed", trackable: schedule.project)
  end

  def send_email
    SchedulesMailer.with(employee: employee, project: schedule.project).relieved_email.deliver_later if deliver_email?
  end

  def deliver_email?
    employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :actor, :schedule, :employee, :project
end
