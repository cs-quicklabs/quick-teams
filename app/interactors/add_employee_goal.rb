class AddEmployeeGoal < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @goal = @employee.goals.new params
    @actor = actor
  end

  def call
    begin
      add_goal
      add_event
      send_email
    rescue
      goal
    end

    goal
  end

  private

  def add_goal
    goal.user_id = actor.id
    goal.save!
  end

  def add_event
    employee.events.create(user: actor, action: "goal", action_for_context: "added goal for", trackable: goal)
  end

  def send_email
    GoalsMailer.with(actor: actor, employee: employee, goal: goal).created_email.deliver_later if deliver_email?
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :employee, :goal, :actor
end
