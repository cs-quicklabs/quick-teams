class NuggetsController < BaseController
  before_action :set_nugget, only: %i[ update destroy edit ]

  def index
    authorize :nugget
    @nugget = Nugget.new
    nuggets = policy_scope(Nugget)
    @pagy, @nuggets = pagy_nil_safe(params, nuggets, items: 20)
    render_partial("nuggets/nugget", collection: @nuggets, cached: true)
  end

  def new
    authorize :nugget
    @nugget = Nugget.new
  end

  def show
    authorize :nugget
    @nuggets = Nugget.find_by_id(params[:id])
    fresh_when @nuggets
  end

  def update
    authorize :nugget
    respond_to do |format|
      if @nugget.update(nugget_params)
        format.turbo_stream { redirect_to nugget_path(@nugget), notice: "Nugget was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@nugget, partial: "nuggets/form", locals: { nugget: @nugget }) }
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Nugget.new, partial: "nuggets/form", locals: { nugget: @nugget }) }
      end
    end
  end

  def edit
    authorize :nugget
  end

  def destroy
    authorize :nugget
    @nugget.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to nuggets_path, notice: "nugget was removed successfully." }
    end
  end

  private

  def set_user
    @user ||= User.find(params["user_id"])
  end

  def set_nugget
    @nugget ||= Nugget.find(params["id"])
  end

  def nugget_params
    params.require(:nugget).permit(:user_id, :title, :skill_id, :body, :published_on, :published)
  end
end
