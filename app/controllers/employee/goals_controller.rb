class Employee::GoalsController < Employee::BaseController
  before_action :set_goal, only: %i[show destroy]

  def index
    authorize @employee, :show_goals?

    @goals = @employee.goals.includes(:user).order(created_at: :desc)
    @goal = Goal.new

    fresh_when @goals
  end

  def create
    authorize @employee, :create_goal?

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
    authorize [:employee, @goal]

    @goal.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@goal) }
    end
  end

  def show
    authorize [:employee, @goal]

    @comment = Comment.new
    fresh_when @goal
  end

  private

  def set_goal
    @goal ||= Goal.find_by(id: params["id"], goalable_type: "User")
  end

  def goal_params
    params.require(:goal).permit(:title, :body, :deadline)
  end
end
