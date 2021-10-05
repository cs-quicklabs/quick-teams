class NuggetsController < BaseController
  before_action :set_nugget, only: %i[ update destroy edit show ]

  def index
    authorize :nugget
    @nugget = Nugget.new
    nuggets = policy_scope(Nugget)
    @pagy, @nuggets = pagy_nil_safe(params, nuggets, items: 20)
    render_partial("nuggets/nugget", collection: @nuggets, cached: true) if stale?(@nuggets)
  end

  def new
    authorize :nugget
    @nugget = Nugget.new
  end

  def show
    authorize @nugget
    fresh_when @nugget
  end

  def update
    authorize [@nugget]
    respond_to do |format|
      if @nugget.update(nugget_params)
        format.turbo_stream { redirect_to nugget_path(@nugget), notice: "Nugget was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@nugget, partial: "nuggets/form", locals: { nugget: @nugget, title: "Edit Nugget" }) }
      end
    end
  end

  def create
    authorize :nugget
    @nugget = AddNugget.call(current_user, nugget_params).result
    respond_to do |format|
      if @nugget.errors.empty?
        format.turbo_stream { redirect_to nuggets_path, notice: "Nugget was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Nugget.new, partial: "nuggets/form", locals: { nugget: @nugget, title: "Add New Nugget" }) }
      end
    end
  end

  def edit
    authorize [@nugget]
  end

  def destroy
    authorize @nugget
    @nugget.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to nuggets_path, status: 303, notice: "Nugget was removed successfully." }
    end
  end

  private

  def set_nugget
    @nugget ||= Nugget.find(params["id"])
  end

  def nugget_params
    params.require(:nugget).permit(:user_id, :title, :skill_id, :body, :published_on, :published)
  end
end
