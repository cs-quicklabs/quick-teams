class Report::GoalsController < Report::BaseController
  def index
    authorize :report

    entries = Goal.includes(:user).query(goal_filter_params)
    entries = entries.includes(:goalable).decorate unless entries.empty?
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/goals/goal", collection: @goals, cached: false) if stale?(@goals)
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
