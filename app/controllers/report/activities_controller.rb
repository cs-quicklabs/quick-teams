class Report::ActivitiesController < Report::BaseController
  def index
    authorize :report
    @event_entries = entries(Event.includes(:trackable, :eventable).where(created_at: params[:from_date]...(params[:to_date].to_date + 1.day).to_s))
    @pagy, @events = pagy_nil_safe(params, @event_entries, items: LIMIT)
    render_partial("report/activities/activity", collection: @events, cached: false)
  end

  private

  def entries(entries)
    if params[:format] == "csv"
      entries
    else
      entries
    end
  end

  def event_filter_params
    params.permit(*EventFilter::KEYS)
  end
end
