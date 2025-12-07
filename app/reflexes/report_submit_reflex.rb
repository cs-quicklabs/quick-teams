class ReportSubmitReflex < ApplicationReflex
  def submit
    report.update!(submitted: true)
    create_submission_event
    morph "#report-status-#{report.id}", render(partial: "shared/reports/status", locals: { report: report, show_submit_button: false })
  end

  private

  def report
    @report ||= Report.find(element.dataset["report-id"])
  end

  def create_submission_event
    report.reportable.events.create(
      user: report.user,
      action: "report",
      action_for_context: "added new report",
      trackable: report,
    )
  end
end
