class Project::ReportsController < Project::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    authorize [@project, Report]
    @pagy, @reports = pagy_nil_safe(params, @project.reports.order(created_at: :desc), items: LIMIT)
    render_partial("project/reports/report", collection: @reports) if stale?(@reports + [@project])
  end

  def new
    authorize [@project, Report]
    @report = Report.new
  end

  def edit
    authorize [@project, @report]
  end

  def create
    authorize [@project, Report]
    @report = AddProjectReport.call(@project, report_params, params[:draft].nil?, current_user).result
    respond_to do |format|
      if @report.errors.empty?
        format.html { redirect_to project_reports_path(@project), notice: "Report was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Report.new, partial: "project/reports/form", locals: { report: @report, title: "Create New Report", subtitle: "Please fill in the details of you new Report." }) }
      end
    end
  end

  def update
    authorize [@project, @report]
    @report = UpdateReport.call(@report, report_params, params[:draft].nil?).result
    respond_to do |format|
      if @report.errors.empty?
        format.html { redirect_to project_reports_path(@project), notice: "Report was successfully updated." }
      else
        format.html { redirect_to edit_employee_report_path(@report), alert: "Failed to update. Please try again." }
      end
    end
  end

  def destroy
    authorize [@project, @report]

    @report.destroy
    Event.where(eventable: @project, trackable: @report).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@report) }
    end
  end

  def show
    authorize [@project, @report]

    fresh_when @reports
  end

  private

  def set_report
    @report ||= Report.find(params["id"])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end
end
