class ProjectTimesheetsStats
  attr_accessor :total_hours, :billable_hours, :billed_hours, :title, :contributors

  def initialize(project, time_span)
    @project = project
    @entries = project.timesheets.where(date: date_range(time_span))
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

  def contributors
    ids = @entries.pluck(:user_id).uniq
    users = User.find(ids)

    contributors = []
    users.each do |user|
      contributor = Contributor.new(user, @entries.where(user: user).sum(:value))
      contributors.push(contributor)
    end

    contributors
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

class Contributor
  def initialize(user, hrs)
    @user = user
    @hrs = hrs
  end

  def display_name
    @user.first_name + " " + @user.last_name
  end

  def contribution
    "#{@hrs} hrs"
  end
end
