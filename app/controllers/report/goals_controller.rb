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
    
    @ids = User.active.joins(:goals).where(:goals=>{:goalable_type=>'User', :deadline => Date.parse(params[:from_date].to_s)..Date.parse(params[:to_date].to_s)}).pluck('DISTINCT goalable_id')
    no_goals = User.where.not(id: @ids)
    @ids.each_with_index do |id,index|
      count = Goal.where(goalable_type:'User',status:0, goalable_id:id, :deadline => Date.parse(params[:from_date].to_s)..Date.parse(params[:to_date].to_s)).group(:goalable_id).count
        if count.empty?
         @ids.delete_at(index)
        end
    end
    employees = User.where(id: @ids).uniq
    @employees= no_goals + employees

    fresh_when @employees
  end




  private

  def goal_filter_params
    params.permit(*GoalFilter::KEYS)
  end
end
