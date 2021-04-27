class Account::RolesController < Account::BaseController
  before_action :set_role, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @roles = Role.all.order(created_at: :desc)
    @role = Role.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:roles, partial: "account/roles/role", locals: { role: @role }) +
                               turbo_stream.replace(Role.new, partial: "account/roles/form", locals: { role: Role.new, message: "Role was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Role.new, partial: "account/roles/form", locals: { role: @role }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @role.update(role_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@role, partial: "account/roles/role", locals: { role: @role, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@role, template: "account/roles/edit", locals: { role: @role, messages: @role.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @role.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@role) }
    end
  end

  private

  def set_role
    @role ||= Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :account_id)
  end
end
