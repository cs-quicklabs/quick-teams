class Report::GoalsController < Report::BaseController
  def index
    entries = Goal.query(goal_filter_params)
    @stats = GoalsStats.new(entries)

    @pagy, @goals = pagy_nil_safe(entries, items: LIMIT)

    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "report/goals/goal", formats: [:html], collection: @goals, cached: true),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
