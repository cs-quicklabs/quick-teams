class ReportSubmitReflex < ApplicationReflex
  def submit
    report = Report.find(element.dataset["report-id"])
    report.update(submitted: true)
    report.save!
  end
end