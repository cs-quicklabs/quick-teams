class AddEmployeeTodo < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @todo = @employee.todos.new params
    @actor = actor
  end

  def call
    begin
      add_todo
      send_email
    rescue
      todo
    end

    todo
  end

  private

  def add_todo
    todo.user_id = actor.id
    todo.owner_id = employee.id
    todo.save!
  end

  def send_email
    TodosMailer.with(actor: actor, employee: employee).added_email.deliver_later if deliver_email?
  end

  def deliver_email?
    actor != employee and employee.email_enabled and employee.account.email_enabled and employee.sign_in_count > 0
  end

  attr_reader :employee, :todo, :actor
end
