class Project::TodosController < Project::BaseController
  before_action :set_todo, only: %i[destroy]

  def index
    authorize [:project, Todo]

    @todo = Todo.new
    @pagy, @todos = pagy_nil_safe(@project.todos.includes({ user: [:role, :job] }).order(created_at: :desc), items: LIMIT)
    render_partial("project/todos/todo", collection: @todos) if stale?(@todos + [@project])
  end

  def create
    authorize [:project, Todo]

    @todo = AddProjectTodo.call(@project, todo_params, current_user).result
    respond_to do |format|
      if @todo.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:todos, partial: "project/todos/todo", locals: { todo: @todo }) +
                               turbo_stream.replace(Todo.new, partial: "project/todos/form", locals: { todo: Todo.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Todo.new, partial: "project/todos/form", locals: { todo: @todo }) }
      end
    end
  end

  def destroy
    authorize [:project, @todo]

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
    params.require(:todo).permit(:owner_id, :discipline_id, :title, :deadline, :completed)
  end
end
