class Project::TodosController < Project::BaseController
  before_action :set_todo, only: %i[destroy]

  def index
    authorize [:project, Todo]

   @pagy, @todos = pagy_nil_safe(@project.todos.includes({ user: [:role, :job] }).order(created_at: :desc), items: LIMIT)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "project/todos/todo", formats: [:html], collection: @todos, cached: true),
        pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
    @todo = Todo.new
  end

  def create
    authorize [:project, Todo]

    @todo = AddTodo.call(Todo.new, @project, User.find_by(id: todo_params["user_id"]), todo_params, current_user).result
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
    params.require(:todo).permit(:user_id, :discipline_id, :title, :deadline, :completed)
  end
end
