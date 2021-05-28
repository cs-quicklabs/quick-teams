class Report::TimesheetsController < Report::BaseController
  def index
    authorize :timesheets
    @filters = TimesheetFilter.new(timesheet_filter_params)
    @timesheet_entries = entries(Timesheet.query(timesheet_filter_params))
    @stats = TimesheetsStats.new(@timesheet_entries)
    @pagy, @timesheets = pagy_nil_safe(@timesheet_entries, items: LIMIT)
    render_partial("report/timesheets/timesheet", collection: @timesheets) if stale?(@timesheets)
  end

  private

  def entries(entries)
    if params[:format] == "csv"
      entries
    else
      entries
    end
  end

  def timesheet_filter_params
    params.permit(*TimesheetFilter::KEYS)
  end
end
