class ReportSubmitReflex < ApplicationReflex
  def submit
    report = Report.find(element.dataset["report-id"])
    report.update(submitted: true)
    reportable = report.reportable
    actor = report.user
    reportable.events.create(user: actor, action: "report", action_for_context: "added new report", trackable: report)
    report.save!
  end

  def download
    html = render(partial: "shared/export")
    morph "#modal", "#{html}"
  end
end
