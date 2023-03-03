class Report::ObserversController < Report::BaseController
  def index
    authorize :report
    @observers = Project.all.active.joins(:project_observers).uniq
    @pagy, @observers = pagy_nil_safe(params, @observers, items: LIMIT)
    render_partial("report/observers/project_observer", collection: @observers, cached: false)
  end
end
