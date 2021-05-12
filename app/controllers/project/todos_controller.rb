class Project::TodosController < Project::BaseController
  before_action :set_todo, only: %i[show destroy edit update]

  def index
    authorize [:project, Todo]

    @todos = @project.todos.includes(:user).order(created_at: :desc).limit(100)
    @todo = Todo.new

    fresh_when @todos
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
    @todo.destroy
    Event.where(eventable: @project, trackable: @todo).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@todo) }
    end
  end

#   def show
#     authorize [:project, @todo]

#     fresh_when @todo
#   end

#   def edit
#     authorize [:project, @todo]
#   end

#   def update
#     authorize [:project, @todo]

#     respond_to do |format|
#       if @todo.update(todo_params)
#         format.html { redirect_to project_todo_path(@todo), notice: "Todo was successfully updated." }
#       else
#         format.html { redirect_to edit_project_todo_path(@todo), alert: "Failed to update. Please try again." }
#       end
#     end
#   end

  private

  def set_todo
    @todo ||= Todo.find_by(id: params["id"])
  end

  def todo_params
    params.require(:todo).permit(:title, :deadline)
  end
end
