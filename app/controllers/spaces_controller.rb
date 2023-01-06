class SpacesController < BaseController
  include Pagy::Backend
  before_action :set_space, only: %i[ show edit update destroy ]

  def index
    authorize :spaces
    @pagy, @spaces = pagy_nil_safe(params, Space.all.order(created_at: :desc), items: LIMIT)
    render_partial("spaces/space", collection: @spaces, cached: true) if stale?(@spaces)
  end

  def new
    authorize :spaces
    @space = Space.new(user_id: current_user.id)
    @users = User.all
  end

  def edit
    authorize :spaces
  end

  def destroy
    authorize :spaces
    @space.destroy
    redirect_to spaces_path, status: 303, notice: "space was removed successfully."
  end

  def update
    authorize :spaces
    if @space.update(space_params)
      redirect_to space_questions_path(@space), notice: "space was updated successfully."
    else
      redirect_to edit_space_path(@space), alert: "Failed to update space."
    end
  end

  def create
    authorize :spaces
    @space = Space.create(space_params)
    respond_to do |format|
      if @space.save
        format.html { redirect_to space_messages_path(@space), notice: "space was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Space.new, partial: "spaces/form", locals: { space: @space, users: User.all, title: "Create New Space", subtitle: "Please fill in the details of you new space." }) }
      end
    end
  end

  private

  def set_space
    @space = Space.find(params[:id])
  end

  def space_params
    params.require(:space).permit(:title, :description, :user_id)
  end
end
