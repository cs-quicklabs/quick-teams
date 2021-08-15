class Employee::NuggetsController < Employee::BaseController
  def index
    authorize [@employee, Nugget]
    @nugget = Nugget.new
    @id = params[:skill_id]

    if !@id.presence
      nuggets = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").includes(:skill).order("read").uniq
    else
      nuggets = @employee.nuggets.select("nuggets_users.read as read", "nuggets.*").where(skill_id: @id).includes(:skill).order("read").uniq
    end

    @pagy, @nuggets = pagy_nil_safe(nuggets, items: 20)
    render_partial("employee/nuggets/nugget", collection: @nuggets, cached: true)
  end

  def pagy_nil_safe(collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  def show
    authorize [@employee, Nugget]
    @nuggets = current_user.nuggets.select("nuggets_users.read as read", "nuggets.*").includes(:skill).find_by_id(params[:id])
    fresh_when @nuggets
  end
end
