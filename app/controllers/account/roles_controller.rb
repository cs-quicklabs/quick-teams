class Account::RolesController < Account::BaseController
  before_action :set_role, only: %i[ show edit update destroy ]

  # GET /roles or /roles.json
  def index
    @roles = Role.all.order(created_at: :desc)
    @role = Role.new
  end

  def edit
  end

  # POST /roles or /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend(:roles, partial: "account/roles/role", locals: { message: "Role was updated successfully.", role: @role }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Role.new, partial: "account/roles/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@role, partial: "account/roles/role", locals: { message: "Role was updated successfully.", role: @role }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@role, partial: "account/roles/role", locals: { role: @role }) }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@role) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:name, :account_id)
  end
end
