class Employee::ReportsController < Employee::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    authorize [@employee, Report]
    @assigns = @employee.templates_assignees.includes(:template)
    employee_reports = @employee.reports.order(created_at: :desc)
    @pagy, @reports = pagy_nil_safe(params, employee_reports, items: LIMIT)
    render_partial("employee/reports/report", collection: @reports) if stale?(@reports + [@employee])
  end

  def new
    authorize [@employee, Report]
    @report = Report.new
    if params[:template_id]
      @template = Template.find(params[:template_id])
      @report.clone(@template, @employee, current_user)
      respond_to do |format|
        format.html { redirect_to edit_employee_report_path(@employee, @report) }
      end
    end
  end

  def create
    authorize [@employee, Report]

    @report = AddEmployeeReport.call(@employee, report_params, params[:draft].nil?, current_user).result
    respond_to do |format|
      if @report.errors.empty?
        format.html { redirect_to employee_reports_path(@employee), notice: "Report was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Report.new, partial: "employee/reports/form", locals: { report: @report, title: "Create New Employee", subtitle: "Please fill in the details of you new Employee." }) }
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
    fresh_when [@report] + @report.comments
  end

  def edit
    authorize [@employee, @report]
  end

  def update
    authorize [@employee, @report]
    @report = UpdateReport.call(@report, report_params, params[:draft].nil?).result
    respond_to do |format|
      if @report.errors.empty?
        format.html { redirect_to employee_reports_path(@employee), notice: "report was successfully updated." }
      else
        format.html { redirect_to edit_employee_report_path(@report.reportable, @report), alert: "Failed to update. Please try again." }
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

  def self?
    current_user == @employee
  end
end
