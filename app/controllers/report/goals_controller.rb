class Report::GoalsController < Report::BaseController
  def index
    authorize :report

    entries = Goal.includes(:user).query(goal_filter_params.except(:order_by, :order), nil, goal_filter_params[:order_by], goal_filter_params[:order])
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/goals/goal", collection: @goals.empty? ? @goals : @goals.includes(:goalable).decorate, cached: false)
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
