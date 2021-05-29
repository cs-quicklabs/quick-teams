class Report::GoalsController < Report::BaseController
  def index
    authorize :report

    entries = Goal.query(goal_filter_params)
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/goals/goal", collection: @goals) if stale?(@goals)
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
