class AddEmployeeTodo < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @todo = employee.todos.new(params)
    @actor = actor
  end

  def call
    add_todo
    send_email
    todo
  rescue StandardError
    todo
  end

  private

  attr_reader :employee, :todo, :actor

  def add_todo
    todo.user_id = actor.id
    todo.owner_id = employee.id
    todo.save!
  end

  def send_email
    return unless deliver_email?

    TodosMailer.with(actor: actor, employee: employee, todo: todo)
               .added_email
               .deliver_later
  end

  def deliver_email?
    actor != employee &&
      employee.email_enabled &&
      employee.account.email_enabled &&
      employee.sign_in_count.positive?
  end
end
