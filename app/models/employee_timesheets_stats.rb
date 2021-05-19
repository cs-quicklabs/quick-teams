class EmployeeTimesheetsStats
  include Statable

  attr_accessor :stats, :title, :contributions, :employee, :from_date, :to_date

  def initialize(employee, time_span)
    @employee = employee
    @time_span = time_span

    @entries = employee.timesheets.where(date: date_range(time_span))
    @stats = TimesheetsStats.new(@entries)
  end

  def contributions
    ids = @entries.pluck(:project_id).uniq
    projects = Project.find(ids)

    contributions = []
    projects.each do |project|
      contribution = Contribution.new(project, @entries.where(project: project).sum(:hours))
      contributions.push(contribution)
    end

    contributions
  end

  def title
    stats_title(@time_span)
  end

  def from_date
    date_range(@time_span).first
  end

  def to_date
    date_range(@time_span).last
  end
end

class Contribution
  def initialize(project, hrs)
    @project = project
    @id = project.id
    @hrs = hrs
  end

  def project
    @project
  end

  def contribution
    "#{@hrs} hrs"
  end
end
