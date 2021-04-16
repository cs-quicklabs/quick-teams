class TimesheetsController < ApplicationController
  def index
    @filter = ["billed", "unbilled"]
    @timesheets = TimesheetDecorator.decorate_collection(Timesheet.all.order(date: :desc))
  end
end
