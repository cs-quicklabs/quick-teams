class Employee::GoalsController < Employee::BaseController
  before_action :set_goal, only: %i[show destroy edit update]

  def index
    authorize [@employee, Goal]

    @goal = Goal.new
    @pagy, @goals = pagy_nil_safe(params, @employee.goals.includes(:user).order(created_at: :desc), items: LIMIT)
    render_partial("employee/goals/goal", collection: @goals) if stale?(@goals + [@employee])
  end

  def create
    authorize [@employee, Goal]

    @goal = AddEmployeeGoal.call(@employee, goal_params, current_user).result

    respond_to do |format|
      if @goal.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:goals, partial: "employee/goals/goal", locals: { goal: @goal }) +
                               turbo_stream.replace(Goal.new, partial: "employee/goals/form", locals: { goal: Goal.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Goal.new, partial: "employee/goals/form", locals: { goal: @goal }) }
      end
    end
  end

  def destroy
    authorize [@employee, @goal]

    @goal.destroy
    Event.where(eventable: @employee, trackable: @goal).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@goal) }
    end
  end

  def show
    authorize [@employee, @goal]

    @comment = Comment.new
    fresh_when [@goal] + @goal.comments
  end

  def edit
    authorize [@employee, @goal]
  end

  def update
    authorize [@employee, @goal]

    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to employee_goal_path(@goal.goalable, @goal), notice: "Goal was successfully updated." }
      else
        format.html { redirect_to edit_employee_goal_path(@goal), alert: "Failed to update. Please try again." }
      end
    end
  end

  private

  def set_goal
    @goal ||= Goal.find_by(id: params["id"], goalable_type: "User")
  end

  def goal_params
    params.require(:goal).permit(:title, :body, :deadline, :permission)
  end
end
