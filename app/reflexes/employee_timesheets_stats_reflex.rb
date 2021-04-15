class EmployeeTimesheetsStatsReflex < ApplicationReflex
  def last_week
    employee = User.find(element.dataset["employee-id"])

    title = "Last Week's Performance"
    stats = EmployeeTimesheetsStats.new(employee, "week")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats, title: title })
  end

  def last_month
    employee = User.find(element.dataset["employee-id"])

    title = "Last Month's Performance"
    stats = EmployeeTimesheetsStats.new(employee, "month")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats, title: title })
  end

  def since_beginning
    employee = User.find(element.dataset["employee-id"])

    title = "Performance since start"
    stats = EmployeeTimesheetsStats.new(employee, "beginning")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats, title: title })
  end
end
