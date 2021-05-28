class Report::TodosController < Report::BaseController
  def my_pending_todos
    authorize :report, :index?

    @todos = Todo.where(completed: false, user: current_user)
  end

  def pending_todos
    authorize :report, :index?

    @todos = Todo.where(completed: false)
  end
end
