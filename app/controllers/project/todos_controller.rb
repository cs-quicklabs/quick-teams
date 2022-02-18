class Project::TodosController < Project::BaseController
  before_action :set_todo, only: %i[destroy edit update show]

  def index
    authorize [@project, Todo]

    @todo = Todo.new
    todos = @project.todos.finished.includes(:project, :user, :owner).order(updated_at: :desc) + @project.todos.pending.includes(:project, :user, :owner).order(deadline: :asc)
    @pagy, @todos = pagy_nil_safe(params, todos, items: LIMIT)
    render_partial("project/todos/todo", collection: @todos) if stale?(@todos + [@project])
  end

  def edit
    authorize [@project, @todo]
  end

  def show
    authorize [@project, @todo]
  end

  def update
    authorize [@project, @todo]

    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to project_todos_path(@project), notice: "Todo was successfully updated." }
      else
        format.html { redirect_to edit_project_todo_path(@project, @todo), alert: "Failed to update. Please try again." }
      end
    end
  end

  def create
    authorize [@project, Todo]

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
    authorize [@project, @todo]

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
    params.require(:todo).permit(:owner_id, :discipline_id, :title, :deadline, :completed, :body)
  end
end
