class Employee::ReportsController < Employee::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    authorize [@employee, Report]

    @report = Report.new
    @pagy, @reports = pagy_nil_safe(params, employee_reports, items: LIMIT)
    render_partial("employee/reports/report", collection: @reports) if stale?(@reports + [@employee])
  end

  def create
    authorize [@employee, Report]

    @report = AddEmployeeReport.call(@employee, report_params, params, current_user).result

    respond_to do |format|
      if @report.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:reports, partial: "employee/reports/report", locals: { report: @report }) +
                               turbo_stream.replace(Report.new, partial: "employee/reports/form", locals: { report: Report.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Report.new, partial: "employee/reports/form", locals: { report: @report }) }
      end
    end
  end

  def destroy
    authorize [@employee, @report]

    @report.destroy
    Event.where(eventable: @employee, trackable: @report).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@report) }
    end
  end

  def show
    authorize [@employee, @report]

    fresh_when @report
  end

  def edit
    authorize [@employee, @report]
  end

  def update
    authorize [@employee, @report]
    @report = UpdateReport.call(@report, report_params, params).result
    respond_to do |format|
      if @report.errors.empty?
        format.html { redirect_to employee_report_path(@report.reportable, @report), notice: "report was successfully updated." }
      else
        format.html { redirect_to edit_employee_report_path(@report), alert: "Failed to update. Please try again." }
      end
    end
  end

  private

  def set_report
    @report ||= Report.find(params["id"])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end

  def employee_reports
    reports = []
    if current_user.admin?
      reports = all_reports
    elsif current_user.lead?
      reports = self? ? submitted_reports : all_reports
    else
      reports = submitted_reports
    end
    reports
  end

  def all_reports
    @employee.reports.order(created_at: :desc)
  end

  def submitted_reports
    @employee.reports.submitted.order(created_at: :desc)
  end

  def self?
    current_user == @employee
  end
end
