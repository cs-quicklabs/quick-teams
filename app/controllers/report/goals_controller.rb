class Report::GoalsController < Report::BaseController
  def index
    authorize :report

    entries = Goal.includes(:user, :goalable).query(goal_filter_params.except(:order_by, :order), nil, goal_filter_params[:order_by], goal_filter_params[:order])
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/goals/goal", collection: @goals.empty? ? @goals : @goals.includes(:goalable).decorate, cached: false)
  end

  def open
    authorize :report, :index?

    date_range = Date.parse(params[:from_date])..Date.parse(params[:to_date])
    @employees_with_goals = User.for_current_account.active.joins(:goals)
      .where(goals: { status: :progress, deadline: date_range }).uniq

    employees = User.for_current_account.active.where.not(id: @employees_with_goals.pluck(:id)).order(:first_name)
    @pagy, @employees = pagy_nil_safe(params, employees, items: LIMIT)
    render_partial("report/goals/employee", collection: @employees, cached: false)
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
