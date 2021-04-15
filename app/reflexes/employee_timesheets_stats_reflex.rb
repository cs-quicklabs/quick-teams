class EmployeeTimesheetsStatsReflex < ApplicationReflex
  def last_week
    employee = User.find(element.dataset["employee-id"])

    stats = EmployeeTimesheetsStats.new(employee, "week")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats })
  end

  def last_month
    employee = User.find(element.dataset["employee-id"])

    stats = EmployeeTimesheetsStats.new(employee, "month")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats })
  end

  def since_beginning
    employee = User.find(element.dataset["employee-id"])

    stats = EmployeeTimesheetsStats.new(employee, "beginning")
    morph "#stats", render(partial: "employee/timesheets/stats", locals: { stats: stats })
  end
end
