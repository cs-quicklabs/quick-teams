class Employee::TodosController < Employee::BaseController
  before_action :set_todo, only: %i[destroy]

  def index
    authorize @employee, :show_todo?

    @todo = @employee.todos.includes(:user).order(created_at: :desc)
    @todo = Todo.new

    fresh_when @todos
  end

  def create
    authorize @employee, :create_todo?

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

  def destroy
    authorize [:employee, @todo]

    @todo.destroy
    Event.where(eventable: @employee, trackable: @todo).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@todo) }
    end
  end

  # def show
  #   authorize [:employee, @todo]

  #   fresh_when @todo
  # end

  # def edit
  #   authorize [:employee, @todo]
  # end

  # def update
  #   authorize [:employee, @todo]

  #   respond_to do |format|
  #     if @todo.update(todo_params)
  #       format.html { redirect_to employee_todo_path(@todo.todoable, @todo), notice: "Todo was successfully updated." }
  #     else
  #       format.html { redirect_to edit_employee_todo_path(@todo), alert: "Failed to update. Please try again." }
  #     end
  #   end
  # end

  private

  def set_todo
    @todo ||= Todo.find_by(id: params["id"])
  end

  def todo_params
    params.require(:todo).permit(:title, :deadline)
  end
end
