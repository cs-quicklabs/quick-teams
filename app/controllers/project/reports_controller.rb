class Project::ReportsController < Project::BaseController
  before_action :set_report, only: %i[show destroy edit update]

  def index
    authorize [@project, Report]

    @report = Report.new
    @pagy, @reports = pagy_nil_safe(params, @project.reports.order(created_at: :desc), items: LIMIT)
    render_partial("project/reports/report", collection: @reports) if stale?(@reports + [@project])
  end
  def edit
   authorize [@project, @report]
  end

  def create
    authorize [@project, Report]
    @report = AddProjectReport.call(@project, report_params, params, current_user).result
    respond_to do |format|
      if @report.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:reports, partial: "project/reports/report", locals: { report: @report }) +
                               turbo_stream.replace(Report.new, partial: "project/reports/form", locals: { report: Report.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Report.new, partial: "project/reports/form", locals: { report: @report }) }
      end
    end
  end

  def update
    authorize [@project, @report]
       @update = UpdateReport.call(@report, report_params, params).result
    respond_to do |format|
      if @update.persisted?
        format.html { redirect_to project_report_path(@report.reportable, @report), notice: "report was successfully updated." }
    
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
