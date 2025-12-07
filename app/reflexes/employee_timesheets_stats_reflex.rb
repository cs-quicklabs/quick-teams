class EmployeeTimesheetsStatsReflex < ApplicationReflex
  def last_week
    render_stats("week")
  end

  def last_month
    render_stats("month")
  end

  def since_beginning
    render_stats("beginning")
  end

  private

  def employee
    @employee ||= User.find(element.dataset["employee-id"])
  end

  def render_stats(period)
    stats = EmployeeTimesheetsStats.new(employee, period)
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { employee_stats: stats })
  end
end
