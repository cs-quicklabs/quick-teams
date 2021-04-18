class ProjectTimesheetsStatsReflex < ApplicationReflex
  def last_week
    project = Project.find(element.dataset["project-id"])

    title = "Last Week's Performance"
    stats = ProjectTimesheetsStats.new(project, "week")
    morph "#stats", render(partial: "project/timesheets/stats", locals: { project_stats: stats, title: title })
  end

  def last_month
    project = Project.find(element.dataset["project-id"])

    title = "Last Month's Performance"
    stats = ProjectTimesheetsStats.new(project, "month")
    morph "#stats", render(partial: "project/timesheets/stats", locals: { project_stats: stats, title: title })
  end

  def since_beginning
    project = Project.find(element.dataset["project-id"])

    title = "Performance since start"
    stats = ProjectTimesheetsStats.new(project, "beginning")
    morph "#stats", render(partial: "project/timesheets/stats", locals: { project_stats: stats, title: title })
  end
end
