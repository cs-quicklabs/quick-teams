class SpacesController < BaseController
  include Pagy::Backend
  before_action :set_space, only: %i[ show edit update destroy pin unpin archive unarchive ]

  def index
    authorize :spaces
    @spaces_page = true
    @pinned_spaces = current_user.pinned.order(created_at: :desc)
    @my_spaces = Space.where(archive: false, user_id: current_user.id).includes(:users).order(created_at: :desc)
    @shared_spaces = current_user.spaces.includes(:users).order(created_at: :desc)
    @archived_spaces = Space.where(archive: true, user_id: current_user.id).includes(:users).order(created_at: :desc)
    render_partial("spaces/space", collection: @my_spaces, cached: true) if stale?(@my_spaces)
  end

  def new
    authorize :spaces
    @space = Space.new(user_id: current_user.id)
    @users = User.for_current_account.active - [current_user]
  end

  def edit
    authorize @space
    @users = User.for_current_account.active - [current_user]
    @space_users = @space.users.pluck(:user_id)
  end

  def create
    authorize :spaces

    @space = AddSpace.call(space_params, current_user, params[:space][:users]).result
    respond_to do |format|
      if @space.persisted?
        format.html { redirect_to space_messages_path(@space), notice: "Space was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Space.new, partial: "spaces/form", locals: { space: @space, users: User.for_current_account.active - [current_user], title: "Add New Space", subtitle: "Please fill in the details of you new space.", url: spaces_path, method: "post", space_users: params[:space][:users] }) }
      end
    end
  end

  def update
    authorize @space
    @space = UpdateSpace.call(@space, current_user, params[:space][:users], space_params).result
    respond_to do |format|
      if @space.errors.empty?
        format.html { redirect_to space_messages_path(@space), notice: "Space was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@space, partial: "spaces/form", locals: { space: @space, users: User.for_current_account.active - [current_user], title: "Edit Space", subtitle: "Please update the details of already existing space.", url: spaces_path, method: "post", space_users: params[:space][:users] }) }
      end
    end
  end

  def destroy
    authorize @space
    @space.destroy
    redirect_to spaces_path, status: 303, notice: "Space was removed successfully."
  end

  def pin
    authorize @space
    current_user.pinned_spaces.create(space: @space)
    respond_to do |format|
      format.html { redirect_to space_messages_path(@space), notice: "Space was pinned successfully." }
    end
  end

  def unpin
    authorize @space
    current_user.pinned.destroy @space
    redirect_to space_messages_path(@space), notice: "Space was unpinned successfully."
  end

  def archive
    authorize @space
    @space.update(archive: true, pin: false, archive_at: Time.now)
    redirect_to space_messages_path(@space), notice: "Space was archived successfully."
  end

  def unarchive
    authorize @space
    @space.update(archive: false)
    redirect_to space_messages_path(@space), notice: "Space was unarchived successfully."
  end

  private

  def set_space
    @space = Space.includes(:users).find(params[:id])
  end

  def space_params
    params.require(:space).permit(:title, :description, :user_id, :users)
  end
end
