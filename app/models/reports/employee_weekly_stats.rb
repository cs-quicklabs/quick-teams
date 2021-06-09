class Reports::EmployeeWeeklyStats
  attr_accessor :hours, :goals, :todos, :employee

  def initialize(employee)
    @employee = employee
    @hours = employee.timesheets.where(date: time_span).sum(:hours)
  end

  private

  def time_span
    ((Date.today - 7)..Date.today)
  end
end
