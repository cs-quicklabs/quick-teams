class ProjectTimesheetsStats
  attr_accessor :stats, :title, :contributors

  def initialize(project, time_span)
    @project = project
    @time_span = time_span
    @entries = project.timesheets.where(date: date_range)
    @stats = TimesheetsStats.new(@entries)
  end

  def contributors
    ids = @entries.pluck(:user_id).uniq
    users = User.find(ids)

    contributors = []
    users.each do |user|
      contributor = Contributor.new(user, @entries.where(user: user).sum(:hours))
      contributors.push(contributor)
    end

    contributors
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
      start_date = 7.days.ago.to_date
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

class Contributor
  def initialize(user, hrs)
    @user = user
    @hrs = hrs
  end

  def employee
    @user
  end

  def display_name
    @user.first_name + " " + @user.last_name
  end

  def contribution
    "#{@hrs} hrs"
  end
end
