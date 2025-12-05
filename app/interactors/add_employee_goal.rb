class AddEmployeeGoal < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @goal = employee.goals.new(params)
    @actor = actor
  end

  def call
    add_goal
    add_event
    send_email
    goal
  rescue StandardError
    goal
  end

  private

  attr_reader :employee, :goal, :actor

  def add_goal
    goal.user_id = actor.id
    goal.save!
  end

  def add_event
    employee.events.create!(
      user: actor,
      action: "goal",
      action_for_context: "added goal for",
      trackable: goal,
    )
  end

  def send_email
    return unless deliver_email?

    GoalsMailer.with(actor: actor, employee: employee, goal: goal)
               .created_email
               .deliver_later
  end

  def deliver_email?
    actor != employee &&
      employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end
end
