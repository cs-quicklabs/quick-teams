class ProjectTimesheetsStatsReflex < ApplicationReflex
  PERIOD_TITLES = {
    "week" => "Last Week's Performance",
    "month" => "Last Month's Performance",
    "beginning" => "Performance since start",
  }.freeze

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

  def project
    @project ||= Project.find(element.dataset["project-id"])
  end

  def render_stats(period)
    stats = ProjectTimesheetsStats.new(project, period)
    morph "#stats", render(partial: "project/timesheets/stats", locals: {
                       project_stats: stats,
                       title: PERIOD_TITLES[period],
                     })
  end
end
