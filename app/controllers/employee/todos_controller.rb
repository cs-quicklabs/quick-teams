class Employee::TodosController < Employee::BaseController
  before_action :set_todo, only: %i[destroy]

  def index
    authorize @employee, :show_todo?

    @todo = Todo.new
    @pagy, @todos = pagy_nil_safe(@employee.todos.includes(:project, :user).order(deadline: :asc), items: LIMIT)
    render_partial("employee/todos/todo", collection: @todos) if stale?(@todos)

  end

  def create
    authorize @employee, :create_todo?

    @todo = AddTodo.call(Todo.new, Project.find_by(id: todo_params["project_id"]), @employee, todo_params, current_user).result

    respond_to do |format|
      if @todo.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:todos, partial: "employee/todos/todo", locals: { todo: @todo }) +
                               turbo_stream.replace(Todo.new, partial: "employee/todos/form", locals: { todo: Todo.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Todo.new, partial: "employee/todos/form", locals: { todo: @todo }) }
      end
    end
  end

  def destroy
    authorize [:employee, @todo]

    @todo = RemoveTodo.call(@todo, current_user).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@todo) }
    end
  end

  private

  def set_todo
    @todo ||= Todo.find_by(id: params["id"])
  end

  def todo_params
    params.require(:todo).permit(:project_id, :discipline_id, :title, :deadline, :completed)
  end
end
