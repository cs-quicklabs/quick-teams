class ProjectTimesheetsStats
  include Statable

  attr_accessor :stats, :title, :contributors, :project, :from_date, :to_date

  def initialize(project, time_span)
    @project = project
    @time_span = time_span
    @entries = project.timesheets.where(date: date_range(time_span))
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
    stats_title(@time_span)
  end

  def from_date
    date_range(@time_span).first
  end

  def to_date
    date_range(@time_span).last
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
