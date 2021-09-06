class Employee::NuggetsController < Employee::BaseController
  before_action :set_nugget, only: [:show]

  def index
    authorize [@employee, Nugget]
    @nugget = Nugget.new

    @pagy, @nuggets = pagy_nil_safe(params, filtered_nuggets, items: 20)
    render_partial("employee/nuggets/nugget", collection: @nuggets, cached: true)
  end

  def show
    authorize [@employee, @nugget]
  end

  def filtered_nuggets
    unless params[:skill_id].present?
      nuggets = @employee.published_nuggets
    else
      nuggets = @employee.published_nuggets_for_skill(params[:skill_id])
    end
  end

  private

  def set_nugget
    @nugget = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").includes(:skill).find_by_id(params[:id])
  end
end
