class ReportSubmitReflex < ApplicationReflex
  def submit
    report = Report.find(element.dataset["report-id"])
    report.update(submitted: true)
    reportable = report.reportable
    actor = report.user
    reportable.events.create(user: actor, action: "report", action_for_context: "added new report", trackable: report)
    report.save!
    morph "#report-status-#{report.id}", render(partial: "shared/reports/status", locals: { report: report, show_submit_button: false })
  end
end
