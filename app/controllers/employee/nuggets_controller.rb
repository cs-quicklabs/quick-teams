class Employee::NuggetsController < Employee::BaseController
  def index
    authorize [@employee, Nugget]
    @nugget = Nugget.new
    @id = params[:skill_id]

    if !@id.presence
      nuggets = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").includes(:skill).order(read: :ASC).order(created_at: :desc).uniq
    else
      nuggets = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").where(skill_id: @id).includes(:skill).order(read: :ASC).order(created_at: :desc).uniq
    end

    @pagy, @nuggets = pagy_nil_safe(nuggets, items: 20)
    render_partial("employee/nuggets/nugget", collection: @nuggets, cached: true)
  end

  def show
    authorize [@employee, Nugget]
    @nuggets = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").includes(:skill).find_by_id(params[:id])
  end
end
