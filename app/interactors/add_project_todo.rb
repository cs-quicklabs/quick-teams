class AddProjectTodo < Patterns::Service
  def initialize(project, params, actor)
    @todo = project.todos.new params
    @project = project
    @actor = actor
    @params = params
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
    todo.project = project
    todo.user_id = actor.id
    todo.save!
  end

  def send_email
    TodosMailer.with(actor: actor, employee: todo.owner, todo: todo).added_email.deliver_later if deliver_email?
  end

  def deliver_email?
    actor != todo.owner and todo.owner.email_enabled and todo.owner.account.email_enabled and todo.owner.sign_in_count > 0
  end

  attr_reader :project, :todo, :actor, :params
end
