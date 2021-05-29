class Report::GoalsController < Report::BaseController
  def index
    authorize :report

    entries = Goal.includes(:user, :goalable).query(goal_filter_params).decorate
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/goals/goal", collection: @goals, cached: false) if stale?(@goals)
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
