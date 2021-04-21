class TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filters = TimesheetFilter.new(timesheet_filter_params)
    @timesheet_entries = entries(Timesheet.query(timesheet_filter_params))
    @timesheets = TimesheetDecorator.decorate_collection(@timesheet_entries)
    @stats = TimesheetsStats.new(@timesheet_entries)
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
