class Report::GoalsController < Report::BaseController
  def index
    @goals = Goal.query(goal_filter_params)
    @stats = GoalsStats.new(@goals)

    fresh_when @goals
  end

  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
