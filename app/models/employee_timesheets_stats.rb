class EmployeeTimesheetsStats
  attr_accessor :stats, :title, :contributions

  def initialize(employee, time_span)
    @employee = employee
    @time_span = time_span

    @entries = employee.timesheets.where(date: date_range)
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
    title_message = ""
    start_date = date_range.first
    end_date = date_range.last
    if @time_span === "week"
      title_message = "Last Week's Performance (#{start_date.to_s(:long)} to #{end_date.to_s(:long)})"
    elsif @time_span === "month"
      title_message = "Last Months's Performance (#{start_date.to_s(:long)} to #{end_date.to_s(:long)})"
    elsif @time_span === "beginning"
      title_message = "Performance since Beginning"
    end
    title_message
  end

  private

  def date_range
    range, start_date, end_date = nil
    if @time_span === "week"
      start_date = 6.days.ago.to_date
      end_date = Date.current
    elsif @time_span === "month"
      start_date = 30.days.ago.to_date
      end_date = Date.current
    elsif @time_span === "beginning"
      start_date = 1000.days.ago.to_date
      end_date = Date.current
    end

    (start_date..end_date)
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
