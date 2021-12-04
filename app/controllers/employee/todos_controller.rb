class Employee::TodosController < Employee::BaseController
  before_action :set_todo, only: %i[destroy edit update show]

  def index
    authorize [@employee, Todo]

    @todo = Todo.new
    @pagy, @todos = pagy_nil_safe(params, @employee.todos.includes(:project, :user, :owner).order(completed: :asc).order(deadline: :asc), items: LIMIT)
    render_partial("employee/todos/todo", collection: @todos) if stale?(@todos + [@employee])
  end

  def create
    authorize [@employee, Todo]

    @todo = AddEmployeeTodo.call(@employee, todo_params, current_user).result

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

  def edit
    authorize [@employee, @todo]
  end

  def show
    authorize [@employee, @todo]
  end

  def update
    authorize [@employee, @todo]

    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to employee_todos_path(@employee), notice: "todo was successfully updated." }
      else
        format.html { redirect_to edit_employee_todo_path(@employee, @todo), alert: "Failed to update. Please try again." }
      end
    end
  end

  def destroy
    authorize [@employee, @todo]

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
    params.require(:todo).permit(:project_id, :discipline_id, :title, :deadline, :completed, :body)
  end
end
