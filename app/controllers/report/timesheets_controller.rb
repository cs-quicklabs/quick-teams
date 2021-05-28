class Report::TimesheetsController < Report::BaseController
  def index
    authorize :report

    @filters = TimesheetFilter.new(timesheet_filter_params)
    @timesheet_entries = entries(Timesheet.query(timesheet_filter_params))
    @stats = TimesheetsStats.new(@timesheet_entries)
    @pagy, @timesheets = pagy_nil_safe(@timesheet_entries, items: LIMIT)

    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "report/timesheets/timesheet", formats: [:html], collection: @timesheets, cached: true),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
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
