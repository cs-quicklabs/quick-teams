class UserController < BaseController
  before_action :authenticate_user!
  before_action :set_user
  before_action :build_form, only: [:update_password, :password]

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { user: @user }) }
      end
    end
  end

  def update_password
    respond_to do |format|
      if @form.submit(change_password_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { message: "Password was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { user: @user }) }
      end
    end
  end

  def profile
  end

  def password
  end

  private

  def set_user
    @user ||= current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :manager_id, :job_id, :discipline_id)
  end

  def change_password_params
    params.require(:user).permit(:original_password, :new_password, :new_password_confirmation)
  end

  def build_form
    @form ||= ChangePasswordForm.new(@user)
  end
end
