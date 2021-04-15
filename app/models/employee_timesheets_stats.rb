class EmployeeTimesheetsStats
  attr_accessor :total_hours, :billable_hours, :billed_hours, :title, :contributions

  def initialize(employee, time_span)
    @employee = employee
    @entries = employee.timesheets.where(date: date_range(time_span))
  end

  def total_hours
    @entries.sum(:value)
  end

  def billable_hours
    @entries.where(billable: true).sum(:value)
  end

  def billed_hours
    @entries.where(billed: true).sum(:value)
  end

  def contributions
    ids = @entries.pluck(:project_id).uniq
    projects = Project.find(ids)

    contributions = []
    projects.each do |project|
      contribution = Contribution.new(project.name, @entries.where(project: project).sum(:value))
      contribution.push(contribution)
    end

    contributions
  end

  private

  def date_range(time_span)
    range, start_date, end_date = nil
    if time_span === "week"
      start_date = 7.days.ago.to_date
      end_date = Date.current
    elsif time_span === "month"
      start_date = 30.days.ago.to_date
      end_date = Date.current
    elsif time_span === "beginning"
      start_date = 1000.days.ago.to_date
      end_date = Date.current
    end

    (start_date..end_date)
  end
end

class Contribution
  def initialize(project_name, hrs)
    @project_name = project_name
    @hrs = hrs
  end

  def name
    @project_name
  end

  def contribution
    "#{@hrs} hrs"
  end
end
